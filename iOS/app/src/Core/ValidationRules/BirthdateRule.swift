//
//  BirthdateRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/11/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator
class BirthdateRule: Rule {
    
    func validate(_ value: String) -> Bool {
        if value.isEmpty {
            return true
        }
        let pattern = "^(0[1-9]|1[0-2])\\/(0[1-9]|1\\d|2\\d|3[01])\\/(19|20)\\d{2}$"
        let range = NSRange(location: 0, length: value.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        
        return regex.firstMatch(in: value, options: [], range: range) != nil
    }
    
    func errorMessage() -> String {
        return "Invalid Birthdate"
    }
    
    init() {
    }
}
