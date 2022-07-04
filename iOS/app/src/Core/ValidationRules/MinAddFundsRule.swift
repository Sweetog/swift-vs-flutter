//
//  MinAddFundsRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/25/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator

class MinAddFundsRule: Rule {
    private let minAmount = 10 //10 dollar min
    
    func validate(_ value: String) -> Bool {
        guard let v = Int(value.numbersOnly()) else {
            return false
        }
        return (v - minAmount) >= 0
    }
    
    func errorMessage() -> String {
        return "Minimum Amount: \(minAmount.displayDollarsNoDecimal())"
    }
}
