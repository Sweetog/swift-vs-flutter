//
//  PurchaseRouter.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/31/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Alamofire

enum PurchaseRouter: URLRequestConvertible {
    static let url = Environment.configuration(.firebaseFunctionsBaseUrl)
    
    case purchase(courseId:String, contestId:String, token:String)
    
    var method: HTTPMethod {
        switch self {
        case .purchase:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .purchase(_, _, _):
            return "purchase"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .purchase(let courseId, let contestId, _):
                return ["courseId": courseId, "contestId": contestId]
            }
        }()
        let url = try UserRouter.url.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        switch self {
        case .purchase(_, _, let token):
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
