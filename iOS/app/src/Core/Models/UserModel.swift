//
//  UserModel.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/9/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//


struct UserModel: Codable {
    var stripeCustomerId: String
    var accountBalance: Int?
    var isAge18Verified: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case stripeCustomerId
        case accountBalance
        case isAge18Verified
    }
    
//    init(uid: String, firstName: String, lastName: String,
//         birthdate: String?, stripeCustomerId: String){
//        self.uid = uid
//        self.firstName = firstName
//        self.lastName = lastName
//        self.birthdate = birthdate
//        self.stripeCustomerId = stripeCustomerId
//    }
}

