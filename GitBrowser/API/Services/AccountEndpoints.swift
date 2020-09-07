//
//  Endpoints.swift
//  GitBrowser
//
//  Created by Igor Shuvalov on 06.09.2020.
//  Copyright © 2020 DevTeam. All rights reserved.
//

import Moya
import Alamofire

enum AccountEndpoints {
    case fetchAccounts(search: AccountSearchOutput)
    case fetchUserInfo(login: String)
    case fetchUserRepos(login: String)
}

extension AccountEndpoints: TargetType {    
    var baseURL: URL {
        switch self {
        case .fetchAccounts, .fetchUserInfo, .fetchUserRepos:
            return URL(string: RequestUrl.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .fetchAccounts:
            return RequestUrl.AccountSearch.search
        case .fetchUserInfo(let login):
            return String(format: RequestUrl.AccountDetail.user, login)
        case .fetchUserRepos(let login):
            return String(format: RequestUrl.AccountDetail.userRepos, login)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchAccounts, .fetchUserInfo, .fetchUserRepos:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
            
        case .fetchAccounts(let search):
            var params: [String: Any] = [:]
            if let sorting = search.sorting {
                params[RequestParam.AccountSearch.sorting] = sorting.rawValue
            }
            params[RequestParam.AccountSearch.name] = search.name
            params[RequestParam.Meta.countPerPage] = search.countPerPage
            params[RequestParam.Meta.pageNumber] = search.pageNumber
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .fetchUserInfo, .fetchUserRepos:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}
