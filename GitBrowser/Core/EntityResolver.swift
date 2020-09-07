//
//  EntityResolver.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

protocol EntityResolverProtocol {
    func resolveAccountSearchVC() -> AccountSearchViewController
    func resolveAccountDetailVC(login: String) -> AccountDetailViewController
}

final class EntityResolver: EntityResolverProtocol {
    func resolveAccountSearchVC() -> AccountSearchViewController {
        let loggerPlugin = NetworkLogger.getPlugin()
        let repository = AccountRepository(provider: .init( plugins: [loggerPlugin]))
        let viewModel = AccountSearchViewModel(repository: repository)
        return AccountSearchViewController(viewModel: viewModel)
    }
    
    func resolveAccountDetailVC(login: String) -> AccountDetailViewController {
        let loggerPlugin = NetworkLogger.getPlugin()
        let repository = AccountRepository(provider: .init( plugins: [loggerPlugin]))
        let viewModel = AccountDetailViewModel(repository: repository, login: login)
        return AccountDetailViewController(viewModel: viewModel)
    }
}
