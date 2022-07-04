//
//  ClaimService.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

class ClaimService {
    static let sharedInstance = ClaimService()
    
    private init() {}
    
    func claim(purchaseId: String, time:String, phone:String, completion: @escaping (Error?) -> Swift.Void) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(tokenError)
                return
            }
            
            API.manager.request(ClaimRouter.claim(purchaseId: purchaseId, time: time, phone: phone, token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        print("ClaimService.claim HTTP error: \(error.localizedDescription)")
                        completion(error)
                    }
            }
        }
    }
    
    func claimCombo(purchaseId: String, time:String, phone:String, comboContestName: String, comboContestPayout: Int, completion: @escaping (Error?) -> Swift.Void) {
        API.getToken { (token, tokenError) in
            if tokenError != nil {
                completion(tokenError)
                return
            }
            
            API.manager.request(ClaimRouter.claimCombo(purchaseId: purchaseId, time: time, phone: phone, comboContestName: comboContestName, comboContestPayout: comboContestPayout, token: token!))
                .validate(statusCode: 200..<300)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        print("ClaimService.claimCombo HTTP error: \(error.localizedDescription)")
                        completion(error)
                    }
            }
        }
    }
}
