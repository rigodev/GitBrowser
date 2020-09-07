//
//  AppCoordinator.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Moya
import UIKit

final class AppCoordinator {
    private let resolver: EntityResolverProtocol
    private let navigation: Navigatable
    private let window: UIWindow
    
    init(resolver: EntityResolverProtocol, window: UIWindow, navigation: Navigatable) {
        self.resolver = resolver
        self.window = window
        self.navigation = navigation
    }
    
    func start() {
        window.rootViewController = navigation.navigationController
        showAccountSearchViewController()
    }
    
    private func showAccountSearchViewController() {
        let controller = resolver.resolveAccountSearchVC()
        controller.delegate = self
        navigation.push(controller)
    }
    
}

extension AppCoordinator: AccountSearchViewControllerDelegate {
    func showAccountDetail(with login: String) {
        let controller = resolver.resolveAccountDetailVC(login: login)
        navigation.push(controller)
    }
}
