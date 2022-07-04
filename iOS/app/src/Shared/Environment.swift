//
//  Environment.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/6/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

public enum PlistKey {
    case facebookUser
    case facebookPassword
    case firstName
    case lastName
    case birthdate
    case displayName
    case phone
    case email
    case password
    case stripePublishableKey
    case appleMerchantIdentifier
    case firebaseFunctionsBaseUrl
    case stripeApiVersion
    
    func value() -> String {
        switch self {
        case .facebookUser:
            return "FACEBOOK_USER"
        case .facebookPassword:
            return "FACEBOOK_PASSWORD"
        case .firstName:
            return "FIRST_NAME"
        case .lastName:
            return "LAST_NAME"
        case .displayName:
            return "DISPLAY_NAME"
        case .birthdate:
            return "BIRTHDATE"
        case .phone:
            return "PHONE"
        case .email:
            return "EMAIL"
        case .password:
            return "PASSWORD"
        case .stripePublishableKey:
            return "STRIPE_PUBLISHABLE_KEY"
        case .appleMerchantIdentifier:
            return "APPLE_MERCHANT_IDENTIFIER"
        case .firebaseFunctionsBaseUrl:
            return "FIREBASE_FUNCTIONS_BASE_URL"
        case .stripeApiVersion:
            return "STRIPE_API_VERSION"
        }
    }
}

public struct Environment {
    
    private init() {
    }
    
    fileprivate static var infoDict: [String: Any] {
        get {
            if let dict = Bundle.main.infoDictionary {
                return dict
            } else {
                fatalError("Plist file not found")
            }
        }
    }
    
    static func configuration(_ key: PlistKey) -> String {
        switch key {
        case .facebookUser:
            return infoDict[PlistKey.facebookUser.value()] as! String
        case .facebookPassword:
            return infoDict[PlistKey.facebookPassword.value()] as! String
        case .firstName:
            return infoDict[PlistKey.firstName.value()] as! String
        case .lastName:
            return infoDict[PlistKey.lastName.value()] as! String
        case .displayName:
            return infoDict[PlistKey.displayName.value()] as! String
        case .birthdate:
            return infoDict[PlistKey.birthdate.value()] as! String
        case .phone:
            return infoDict[PlistKey.phone.value()] as! String
        case .email:
                return infoDict[PlistKey.email.value()] as! String
        case .password:
            return infoDict[PlistKey.password.value()] as! String
        case .stripePublishableKey:
            return infoDict[PlistKey.stripePublishableKey.value()] as! String
        case .appleMerchantIdentifier:
            return infoDict[PlistKey.appleMerchantIdentifier.value()] as! String
        case .firebaseFunctionsBaseUrl:
            return infoDict[PlistKey.firebaseFunctionsBaseUrl.value()] as! String
        case .stripeApiVersion:
            return infoDict[PlistKey.stripeApiVersion.value()] as! String
        }
    }
    
    private static let production : Bool = {
        #if DEVELOPMENT
        print("DEVELOPMENT")
        return false
        #elseif DEBUG
        print("DEBUG")
        return false
        #else
        print("PRODUCTION/RELEASE")
        return true
        #endif
    }()
    
    static func isProduction () -> Bool {
        return self.production
    }
}
