//
//  Router.swift
//  FanfouExpress
//
//  Created by Cencen Zheng on 3/23/17.
//  Copyright © 2017 Cencen Zheng. All rights reserved.
//

import Foundation
import Alamofire

enum Shift: String {
    case daily
    case weekly
}

enum Router: URLRequestConvertible {
    case fetchDailyDigests(date: String)
    case fetchWeeklyDigest(date: String)
    case fetchDigests(shift: Shift, date: String)
    
    static let baseUrl = "http://blog.fanfou.com/digest/json"
    
    var path: String {
        switch self {
        case .fetchDigests(let shift, let date):
            return "/\(date).\(shift.rawValue).json"
        case .fetchDailyDigests(let date):
            return "/\(date).\(Shift.daily.rawValue).json"
        case .fetchWeeklyDigest(let date):
            return "/\(date).\(Shift.weekly.rawValue).json"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseUrl.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = HTTPMethod.get.rawValue
        
        return request
    }
}
