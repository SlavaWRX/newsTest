//
//  NewsTarget.swift
//  News
//
//  Created by Viacheslav Goroshniuk on 9/23/19.
//  Copyright © 2019 Viacheslav Goroshniuk. All rights reserved.
//

import Foundation
import Moya

enum NewsTerget {
    case getNews(page: Int, perPage: Int)
}

extension NewsTerget: TargetType {
    var baseURL: URL {
        switch self {
        case .getNews(let page, let perPage):
            return URL(string: Constants.API.baseAPIURL + "?country=\(Constants.API.country)" + "&apiKey=\(Constants.API.apiKey)" + "&pageSize=\(perPage)" + "&page=\(page)")!
        }
    }
    
    var path: String {
        switch self {
        case .getNews:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNews:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var parameters = [String: Any]()
        switch self {
        case .getNews:
            //            parameters["country"] = "ua"
            //            parameters["apiKey"] = Constants.API.apiKey
            //            return .requestParameters(parameters: parameters, encoding: JSONEncoding())
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        var headers: [String: String] = [:]
        //        headers["country"] = "ua"
        //        headers["apiKey"] = Constants.API.apiKey
        return headers
    }
    
    
}
