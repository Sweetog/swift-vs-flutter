//
//  CurrentUser.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//


final class CurrentUser {
    
    static let sharedInstance = CurrentUser()
    
    private init() { }
    
    private let uidKey = "uidKey"
    var uid: String? {
        get {
            guard let retVal = UserDefaultsUtility.getUserDefaultString(key: uidKey) else {
                return nil
            }
            
            return retVal
        }
        set {
            if let newValue = newValue {
                UserDefaultsUtility.set(value: newValue, key: uidKey)
            }
        }
    }
    
    private let emailKey = "emailKey"
    var email: String? {
        get {
            guard let retVal = UserDefaultsUtility.getUserDefaultString(key: emailKey) else {
                return nil
            }
            
            return retVal
        }
        set {
            if let newValue = newValue {
                UserDefaultsUtility.set(value: newValue, key: emailKey)
            }
        }
    }
    
    private let displayNameKey = "displayNameKey"
    var displayName: String? {
        get {
            guard let retVal = UserDefaultsUtility.getUserDefaultString(key: displayNameKey) else {
                return nil
            }
            
            return retVal
        }
        set {
            if let newValue = newValue {
                UserDefaultsUtility.set(value: newValue, key: displayNameKey)
            }
        }
    }
    
    private let stripeCustomerIdKey = "stripeCustomerIdKey"
    var stripeCustomerId: String? {
        get {
            guard let retVal = UserDefaultsUtility.getUserDefaultString(key: stripeCustomerIdKey) else {
                return nil
            }
            
            return retVal
        }
        set {
            if let newValue = newValue {
                UserDefaultsUtility.set(value: newValue, key: stripeCustomerIdKey)
            }
        }
    }
    
    private let accountBalanceKey = "accountBalanceKey"
    var accountBalance: Int? {
        get {
            guard let retVal = UserDefaultsUtility.getUserDefaultInt(key: accountBalanceKey) else {
                return nil
            }
            
            return retVal
        }
        set {
            if let newValue = newValue {
                UserDefaultsUtility.set(value: newValue, key: accountBalanceKey)
            }
        }
    }
    
    func clearAllValues() {
        self.uid = nil
        self.email = nil
        self.displayName = nil
        self.stripeCustomerId = nil
        self.accountBalance = nil
    }

}

