//
//  AccountSearchResponse.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

struct AccountSearchResponse: Decodable {
    let totalCount: Int
    let items: [Item]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
    
    struct Item: Decodable {
        let id: Int
        let login: String
        let avatarPath: String
        let typeName: String
        
        private enum CodingKeys: String, CodingKey {
            case id
            case login
            case avatarPath = "avatar_url"
            case typeName = "type"
        }
    }
}
