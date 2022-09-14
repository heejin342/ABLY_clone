//
//  HomeService.swift
//  Ably
//
//  Created by 김희진 on 2022/09/06.
//

import Foundation
import Moya

enum HomeSerice {
    case home
    case goodsByLastId(_ lastId: Int)
}

extension HomeSerice: TargetType {
    
    public var baseURL: URL {
        return URL(string: AblyKey.urlString)!
    }

    var path: String {
        switch self {
        case .home:
            return "/home"
        case .goodsByLastId(_):
            return "/home/goods"
        }
    }

    var method: Moya.Method {
        switch self {
        case .home,
             .goodsByLastId:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .home:
            return .requestPlain
        case .goodsByLastId(let lastId):
            let params: [String: Any] = [
                "lastId": lastId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
