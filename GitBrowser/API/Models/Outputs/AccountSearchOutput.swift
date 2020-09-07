//
//  AccountSearchOutput.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

struct AccountSearchOutput {
    let sorting: Sorting?
    let name: String
    let pageNumber: Int
    let countPerPage: Int
    
    enum Sorting: String {
        case account = "account"
    }
}
