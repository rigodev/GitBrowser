//
//  UserRepo.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 07.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

struct UserRepo: Equatable {
    let id: Int
    let name: String?
    let language: String?
    var shouldShowDescription: Bool
    let updated: String
    let starsCount: String
}
