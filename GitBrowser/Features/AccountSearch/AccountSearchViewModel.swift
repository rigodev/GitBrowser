//
//  AccountSearchViewModel.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import ReactorKit
import RxSwift

final class AccountSearchViewModel: Reactor {
    private let repository: AccountRepositoryProtocol
    private let accountsPerPage = 20
    
    let initialState: State
    
    struct State {
        var sortingIsOn = false
        var accounts: [AccountCommonInfo] = []
        var searchName = ""
        var pageNumber = 1
        var totalCount = 0
        var isLoading = false
    }
    
    enum Action {
        case getAccounts(name: String?)
        case getNextAccounts
        case sortingIsOnChanged(Bool)
    }
    
    enum Mutation {
        case setIsLoading(Bool)
        case setSearchName(String)
        case setPageNumber(Int)
        case setTotalCount(Int)
        case setAccounts([AccountCommonInfo])
        case appendAccounts([AccountCommonInfo])
        case setSortingIsOn(Bool)
    }
    
    init(repository: AccountRepositoryProtocol) {
        self.repository = repository
        initialState = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getAccounts(let searchString):
            guard currentState.isLoading == false else { return .empty() }
            
            let isSorted = currentState.sortingIsOn
            let initialPageNumber = initialState.pageNumber
            let initialTotalCount = initialState.totalCount
            
            let searchAccounts: Observable<Mutation>
            if let name = searchString?.trimmingCharacters(in: .whitespacesAndNewlines),
                !name.isEmpty {
                searchAccounts = .concat([
                    .just(.setSearchName(name)),
                    getAccounts(isSorted: isSorted, name: name, pageNumber: initialPageNumber, countPerPage: accountsPerPage)
                ])
            } else {
                searchAccounts = .just(.setSearchName(initialState.searchName))
            }
            
            return .concat([
                .just(.setAccounts([])),
                .just(.setPageNumber(initialPageNumber)),
                .just(.setTotalCount(initialTotalCount)),
                .just(.setIsLoading(true)),
                searchAccounts,
                .just(.setIsLoading(false))
            ])
            
        case .getNextAccounts:
            guard
                currentState.isLoading == false,
                !currentState.searchName.isEmpty,
                hasPages()
            else { return .empty() }
            
            let isSorted = currentState.sortingIsOn
            let name = currentState.searchName
            let nextPageNumber = currentState.pageNumber + 1
            
            return .concat([
                .just(.setIsLoading(true)),
                getAccounts(isSorted: isSorted, name: name, pageNumber: nextPageNumber, countPerPage: accountsPerPage),
                .just(.setIsLoading(false))
            ])
            
        case .sortingIsOnChanged(let isOn):
            return .just(.setSortingIsOn(isOn))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setIsLoading(let isLoading):
            newState.isLoading = isLoading
        case .setSearchName(let searchName):
            newState.searchName = searchName
        case .setPageNumber(let pageNumber):
            newState.pageNumber = pageNumber
        case .setTotalCount(let totalCount):
            newState.totalCount = totalCount
        case .setAccounts(let accounts):
            newState.accounts = accounts
        case .appendAccounts(let accounts):
            newState.accounts.append(contentsOf: accounts)
        case .setSortingIsOn(let isOn):
            newState.sortingIsOn = isOn
        }
        
        return newState
    }
    
}

private extension AccountSearchViewModel {
    func getAccounts(isSorted: Bool, name: String, pageNumber: Int, countPerPage: Int) -> Observable<Mutation> {
        let search = AccountSearchOutput(
            sorting: isSorted ? .account : nil,
            name: name,
            pageNumber: pageNumber,
            countPerPage: countPerPage)
        return repository.fetchAccounts(with: search)
            .asObservable()
            .flatMap({ response -> Observable<Mutation> in
                let totalCount = response.totalCount
                let accounts = response.items.map {
                    AccountCommonInfo(
                        id: $0.id,
                        login: $0.login,
                        avatarPath: $0.avatarPath,
                        typeName: $0.typeName)
                }
                return .of(.setPageNumber(pageNumber),
                           .setTotalCount(totalCount),
                           .appendAccounts(accounts))
            })
            .catchErrorJustReturn(.setIsLoading(false))
    }
    
    func hasPages() -> Bool {
        return currentState.pageNumber * accountsPerPage < currentState.totalCount
    }    
}
