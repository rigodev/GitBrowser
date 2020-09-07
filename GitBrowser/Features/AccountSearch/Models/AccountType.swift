//
//  AccountType.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

enum AccountType: Equatable {
    case user
    case organization
    case unknown(String)
    
    var description: String {
        switch self {
        case .user:
            return "Пользователь"
        case .organization:
            return "Организация"
        case .unknown(let name):
            return "Неизвестный тип: \(name)"
        }
    }
    
    init(with typeName: String) {
        switch typeName.lowercased() {
        case "user":
            self = .user
        case "organization":
            self = .organization
        default:
            self = .unknown(typeName)
        }
    }
}
