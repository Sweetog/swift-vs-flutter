//
//  StripeService.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import SwiftyJSON

class StripeService: NSObject, STPEphemeralKeyProvider {
    
    static let sharedInstance = StripeService()
    
    private override init() {}
    
    func completeCharge(_ result: STPPaymentResult, amount: Int, completion: @escaping STPErrorBlock) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(tokenError)
                return
            }
            
            API.manager.request(StripeRouter.completeCharge(result, amount: amount, currency: "usd", token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        print("StripeService.completCharge HTTP error: \(error.localizedDescription)")
                        completion(error)
                    }
            }
        }
    }
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(nil, tokenError)
                return
            }
            
            API.manager.request(StripeRouter.createCustomerKey(token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        completion(json as? [String: AnyObject], nil)
                    case .failure(let error):
                        print("StripeService.createCustomerKey HTTP error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
            }
        }
    }
}


//    func completeCharge(_ result: STPPaymentResult,
//                        amount: Int,
//                        shippingAddress: STPAddress?,
//                        shippingMethod: PKShippingMethod?,
//                        completion: @escaping STPErrorBlock) {
//        let url = self.baseURL.appendingPathComponent("charge")
//        var params: [String: Any] = [
//            "source": result.source.stripeID,
//            "amount": amount,
//            "metadata": [
//                // example-ios-backend allows passing metadata through to Stripe
//                "charge_request_id": "B3E611D1-5FA1-4410-9CEC-00958A5126CB",
//            ],
//            ]
//        params["shipping"] = STPAddress.shippingInfoForCharge(with: shippingAddress, shippingMethod: shippingMethod)
//        Alamofire.request(url, method: .post, parameters: params)
//            .validate(statusCode: 200..<300)
//            .responseString { response in
//                switch response.result {
//                case .success:
//                    completion(nil)
//                case .failure(let error):
//                    completion(error)
//                }
//        }
//    }
