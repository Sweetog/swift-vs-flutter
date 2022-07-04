//
//  PhoneRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/11/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator

class PhoneRule: RegexRule {
    
    static let regex = "^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]\\d{3}[\\s.-]\\d{4}$"
    
    convenience init(message : String = "Not a valid 10 digit US Phone Number"){
        self.init(regex: PhoneRule.regex, message : message)
    }
}
