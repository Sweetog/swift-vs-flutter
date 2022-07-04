//
//  ClaimRouter.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Alamofire

enum ClaimRouter: URLRequestConvertible {
    static let url = Environment.configuration(.firebaseFunctionsBaseUrl)
    
    case claim(purchaseId: String, time:String, phone:String, token:String)
    case claimCombo(purchaseId: String, time:String, phone:String, comboContestName: String, comboContestPayout: Int, token:String)
    
    var method: HTTPMethod {
        switch self {
        case .claim, .claimCombo:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .claim(_, _, _, _), .claimCombo(_, _, _, _, _, _):
            return "claim"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .claim(let purchaseId, let time, let phone, _):
                return ["purchaseId": purchaseId, "time": time, "phone": phone]
            case .claimCombo(let purchaseId, let time, let phone, let comboContestName, let comboContestPayout, _):
                return ["purchaseId": purchaseId, "time": time, "phone": phone, "comboContestName": comboContestName, "comboContestPayout":comboContestPayout]
            }
        }()
        let url = try UserRouter.url.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        switch self {
        case .claim(_, _, _, let token), .claimCombo(_, _, _, _, _, let token):
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}

