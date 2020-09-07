//
//  Navigation.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import UIKit

protocol Navigatable {
    var navigationController: UINavigationController { get }
    
    func push(_ controller: UIViewController)
}


final class Navigation: Navigatable {
    let navigationController: UINavigationController
    
    init() {
        navigationController = UINavigationController()
    }
    
    func push(_ controller: UIViewController) {
        navigationController.pushViewController(controller, animated: true)
    }
    
}
