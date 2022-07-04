//
//  BmsPasswordRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/12/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator

class BmsPasswordRule: RegexRule {
    static let regex = "^(?=.*\\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*?]{6,}$"
    
    convenience init(message : String = "At least: 6 chars, 1 letter, 1 number"){
        self.init(regex: BmsPasswordRule.regex, message : message)
    }
}
