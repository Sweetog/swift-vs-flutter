//
//  PurchaseService.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/31/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

class PurchaseService {
    static let sharedInstance = PurchaseService()
    
    private init() {}
    
    func purchase(courseId: String, contestId:String, completion: @escaping (Error?) -> Swift.Void) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(tokenError)
                return
            }
            
            API.manager.request(PurchaseRouter.purchase(courseId: courseId, contestId: contestId, token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        print("PurchaseService.purchase HTTP error: \(error.localizedDescription)")
                        completion(error)
                    }
            }
        }
    }
}
