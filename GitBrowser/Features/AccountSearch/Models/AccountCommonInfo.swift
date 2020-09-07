//
//  AccountCommonInfo.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Foundation

struct AccountCommonInfo: Equatable {
    let id: Int
    let login: String
    let avatarPath: String
    let type: AccountType
    
    init(id: Int,
         login: String,
         avatarPath: String,
         typeName: String) {
        self.id = id
        self.login = login
        self.avatarPath = avatarPath
        type = .init(with: typeName)
    }
}
