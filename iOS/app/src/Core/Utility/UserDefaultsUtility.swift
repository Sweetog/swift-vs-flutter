//
//  UserDefaultsUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/12/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

struct UserDefaultsUtility {
    private static var sessionOnlyKeys:[String]?
    
    static func getUserDefaultBool(key: String) -> Bool? {
        return getUserDefaultValue(key: key) as? Bool
    }
    
    static func getUserDefaultInt(key: String) -> Int? {
        return getUserDefaultValue(key: key) as? Int
    }
    
    static func getUserDefaultDouble(key: String) -> Double? {
        return getUserDefaultValue(key: key) as? Double
    }
    
    static func getUserDefaultString(key: String) -> String? {
        return getUserDefaultValue(key: key) as? String
    }
    
    static func getUserDefaultValue(key: String) -> Any? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    
    static func set(value: Any, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func setForSession(value: Any, key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    static func remove(key: String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
    }
    
    static func clearSession() {
        guard let sessionOnlyKeys = sessionOnlyKeys else {
            return
        }
        
        for key in sessionOnlyKeys {
            remove(key: key)
        }
    }
    
    // MARK - Private Helpers
    private static func addKeyForSession(key: String) {
        if sessionOnlyKeys == nil {
            sessionOnlyKeys = [key]
            return
        }
        
        sessionOnlyKeys?.append(key)
    }
}
