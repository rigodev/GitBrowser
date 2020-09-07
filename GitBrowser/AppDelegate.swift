//
//  AppDelegate.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var coordinator: AppCoordinator!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        let entityResolver = EntityResolver()
        let navigation = Navigation()
        
        coordinator = AppCoordinator(
            resolver: entityResolver,
            window: window,
            navigation: navigation)
        coordinator.start()
        window.makeKeyAndVisible()
        
        return true
    }
    
}
