//
//  UserInfoResponse.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

struct UserInfoResponse: Decodable {
    let login: String
    let name: String?
    let avatarPath: String
    let location: String?
    let created: String
    
    private enum CodingKeys: String, CodingKey {
        case login
        case name
        case avatarPath = "avatar_url"
        case location
        case created = "created_at"
    }
}
