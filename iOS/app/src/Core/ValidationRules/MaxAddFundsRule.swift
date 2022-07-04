//
//  MaxOtherAccountBalanceRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/25/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator

class MaxAddFundsRule: Rule {
    private let maxAmount = 1000//thousand cap
    
    func validate(_ value: String) -> Bool {
        guard let v = Int(value.numbersOnly()) else {
            return false
        }
        
        return (maxAmount - v) >= 0
    }
    
    func errorMessage() -> String {
        return "Maximum Amount: \(maxAmount.displayDollarsNoDecimal())"
    }
}
