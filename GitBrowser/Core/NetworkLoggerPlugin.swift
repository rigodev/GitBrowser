//
//  NetworkLoggerPlugin.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Moya

final class NetworkLogger {
    static func getPlugin() -> NetworkLoggerPlugin {
        var configuration = NetworkLoggerPlugin.Configuration()
        configuration.logOptions = .verbose
        
        let networkLoggerPlugin = NetworkLoggerPlugin(configuration: configuration)
        return networkLoggerPlugin
    }
    
}
