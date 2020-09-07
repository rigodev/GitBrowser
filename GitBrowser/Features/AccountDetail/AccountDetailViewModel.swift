//
//  AccountDetailViewModel.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import ReactorKit
import RxSwift

final class AccountDetailViewModel: Reactor {
    private let repository: AccountRepositoryProtocol
    
    let initialState: State
    
    struct State {
        let login: String
        var isLoading = false
        var userInfo: UserInfo?
        var repos: [UserRepo] = []
    }
    
    enum Action {
        case getUser
        case descriptionTap(index: Int)
    }
    
    enum Mutation {
        case setIsLoading(Bool)
        case setUserInfo(UserInfo)
        case setUserRepos([UserRepo])
        case updateRepo(index: Int, showDescription: Bool)
    }
    
    init(repository: AccountRepositoryProtocol, login: String) {
        self.repository = repository
        initialState = .init(login: login)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getUser:
            let login = currentState.login
            return Observable.concat([
                .just(.setIsLoading(true)),
                repository.fetchUserInfo(with: login)
                    .asObservable()
                    .flatMap({ [unowned self] response -> Observable<Mutation> in
                        let userInfo = UserInfo(
                            login: response.login,
                            name: response.name,
                            avatarPath: response.avatarPath,
                            location: response.location,
                            created: response.created)
                        let repos = self.getUserRepos(with: login)
                        return .concat(.just(.setUserInfo(userInfo)), repos)
                    }),
                .just(.setIsLoading(false))
            ])
                .catchErrorJustReturn(.setIsLoading(false))
            
        case .descriptionTap(let index):
            return .just(.updateRepo(index: index, showDescription: true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setIsLoading(let isLoading):
            newState.isLoading = isLoading
        case .setUserInfo(let userInfo):
            newState.userInfo = userInfo
        case .setUserRepos(let repos):
            newState.repos = repos
        case let .updateRepo(index, showDescription):
            newState.repos[index].shouldShowDescription = showDescription
        }
        
        return newState
    }
    
}

private extension AccountDetailViewModel {
    func getUserRepos(with login: String) -> Observable<Mutation> {
        return repository.fetchUserRepos(with: login)
            .asObservable()
            .map({ response in
                let repos = response.map { UserRepo(id: $0.id, name: $0.name, language: $0.language, shouldShowDescription: false, updated: $0.updated, starsCount: String($0.starsCount))}
                return .setUserRepos(repos)
            })
            .catchErrorJustReturn(.setUserRepos([]))
    }
}
