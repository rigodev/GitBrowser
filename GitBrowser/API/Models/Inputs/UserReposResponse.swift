//
//  UserReposResponse.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

struct UserReposResponse: Decodable {
    let id: Int
    let name: String?
    let language: String?
    let updated: String
    let starsCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case language
        case updated = "updated_at"
        case starsCount = "stargazers_count"
    }
}
