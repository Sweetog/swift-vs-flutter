//
//  BirthdayValidationRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/8/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator

class BirthdateRuleOld: RegexRule {
    
    static let regex = "^(0[1-9]|1[0-2])\\/(0[1-9]|1\\d|2\\d|3[01])\\/(19|20)\\d{2}$"
    
    convenience init(message : String = "Not a valid birth date: MM/DD/YYYY"){
        self.init(regex: BirthdateRuleOld.regex, message : message)
    }
}
