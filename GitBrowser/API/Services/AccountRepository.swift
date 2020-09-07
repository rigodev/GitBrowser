//
//  AccountRepository.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Moya
import RxSwift

protocol AccountRepositoryProtocol {
    func fetchAccounts(with search: AccountSearchOutput) -> Single<AccountSearchResponse>
    func fetchUserInfo(with login: String) -> Single<UserInfoResponse>
    func fetchUserRepos(with login: String) -> Single<[UserReposResponse]>
}

final class AccountRepository: AccountRepositoryProtocol {
    private let provider: MoyaProvider<AccountEndpoints>
    
    init(provider: MoyaProvider<AccountEndpoints>) {
        self.provider = provider
    }
    
    func fetchAccounts(with search: AccountSearchOutput) -> Single<AccountSearchResponse> {
        return provider.rx.request(.fetchAccounts(search: search))
            .map(AccountSearchResponse.self)
    }
    
    func fetchUserInfo(with login: String) -> Single<UserInfoResponse> {
        return provider.rx.request(.fetchUserInfo(login: login))
            .map(UserInfoResponse.self)
    }
    
    func fetchUserRepos(with login: String) -> Single<[UserReposResponse]> {
        return provider.rx.request(.fetchUserRepos(login: login))
            .map([UserReposResponse].self)
    }
    
}
