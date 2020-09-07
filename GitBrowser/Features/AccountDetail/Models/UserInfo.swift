//
//  UserInfo.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Foundation

struct UserInfo: Equatable {
    let login: String
    let name: String?
    let avatarPath: String
    let location: String?
    let created: String
}
