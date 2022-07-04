//
//  UserRouter.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Alamofire

enum UserRouter: URLRequestConvertible {
    static let url = Environment.configuration(.firebaseFunctionsBaseUrl)
 
    case createUser(email:String, isAge18Verified: Bool, token:String)
    case getUser(token:String)
    
    var method: HTTPMethod {
        switch self {
        case .createUser:
            return .post
        case .getUser:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createUser(_, _, _), .getUser(_):
            return "user"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .createUser(let email, let isAge18Verified, _):
                return ["email": email, "isAge18Verified": (isAge18Verified) ? "true" : "false"] //Alamofire will serialize Bool to AnyObject (1,0)
            case .getUser(_):
                return [:]
            }
        }()
        let url = try UserRouter.url.asURL()
        print("url \(url)")
        var request = URLRequest(url: url.appendingPathComponent(path))
        switch self {
        case .createUser(_, _, let token), .getUser(let token):
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
