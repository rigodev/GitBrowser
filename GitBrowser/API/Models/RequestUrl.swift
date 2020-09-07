//
//  RequestUrl.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

enum RequestUrl {
    static let baseUrl = "https://api.github.com/"
    
    enum AccountSearch {
        static let search = "search/users"
    }
    
    enum AccountDetail {
        static let user = "users/%@"
        static let userRepos = "users/%@/repos"
    }
}
