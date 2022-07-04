//
//  StripeRouter.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

enum StripeRouter: URLRequestConvertible {
    static let url = Environment.configuration(.firebaseFunctionsBaseUrl)
    static let stripeApiVersion = Environment.configuration(.stripeApiVersion)
    
    case createCustomerKey(token: String)
    case completeCharge(_ result: STPPaymentResult, amount: Int, currency: String, token: String)
    
    var method: HTTPMethod {
        switch self {
        case .createCustomerKey:
            return .post
        case .completeCharge:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .createCustomerKey(_):
            return "ephemeralKey"
        case .completeCharge(_, _, _, _):
            return "charge"
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let parameters: [String: Any] = {
            switch self {
            case .createCustomerKey(_):
                return ["api_version": StripeRouter.stripeApiVersion]
            case .completeCharge(let result, let amount, let currency, _):
                return ["source": result.source.stripeID, "amount": amount, "currency": currency]
            }
        }()
        let url = try StripeRouter.url.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        switch self {
        case .createCustomerKey(let token), .completeCharge(_, _, _, let token):
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
