//
//  RequestParam.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

enum RequestParam {
    
    enum Meta {
        static let pageNumber = "page"
        static let countPerPage = "per_page"
    }
    
    enum AccountSearch {
        static let name = "q"
        static let sorting = "sort"
    }
}
