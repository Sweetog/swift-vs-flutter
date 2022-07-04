//
//  UserService.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

class UserService {
    static let sharedInstance = UserService()
    
    private init() {}
    
    func getUser(completion: @escaping (UserModel?, Error?) -> Swift.Void) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(nil, tokenError)
                return
            }
            
            API.manager.request(UserRouter.getUser(token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        if let dic = json as? [String: AnyObject] {
                            let accountBalance = dic["accountBalance"] as? Int
                            let stripeCustomerId = dic["stripeCustomerId"] as! String
                            let userModel = UserModel.init(stripeCustomerId: stripeCustomerId, accountBalance: accountBalance, isAge18Verified: nil)
                            completion(userModel, nil)
                            return
                        }
                        print("UserService.getUser error creating Stripe Customer Model")
                        completion(nil, nil)
                    case .failure(let error):
                        print("UserService.getUser HTTP error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
            }
        }
    }
    
    func createUser(email: String, isAge18: Bool, completion: @escaping (UserModel?, Error?) -> Swift.Void) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(nil, tokenError)
                return
            }
            
            API.manager.request(UserRouter.createUser(email: email, isAge18Verified: isAge18, token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        if let dic = json as? [String: AnyObject] {
                            let stripeCustomerId = dic["stripeCustomerId"] as! String
                            let userModel = UserModel.init(stripeCustomerId: stripeCustomerId, accountBalance: nil, isAge18Verified: isAge18)
                            completion(userModel, nil)
                            return
                        }
                        print("UserService.createUser error creating Stripe Customer Model")
                        completion(nil, nil)
                    case .failure(let error):
                        print("UserService.createUser HTTP error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
            }
        }
    }
}
