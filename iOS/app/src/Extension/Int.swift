//
//  Int.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/24/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

extension Int {
    func convertAccountBalanceToDollars() -> Double {
        return convertCentsToDollars(val: self)
    }
    
    func displayDollarsNoDecimal() -> String {
        return displayDollars(val: Double(self))
    }
    
    func displayCentsInDollarsNoDecimal() -> String {
        return displayCentsInDollarsNoDecimal(value: self)
    }
    
    func displayAccountBalanceNoDecimal() -> String {
        return displayCentsInDollarsNoDecimal(value: -1 * self)
    }
    
    //account ledge credits are negative thus the -1 *
    func displayAccountBalance() -> String {
        //return String(format: "$%.02f", -1 * convertCentsToDollars(val: self))
        var multiplier = -1.0
        if self == 0 {
            multiplier = 1.0
        }
        return displayDollars(val: multiplier * convertCentsToDollars(val: self))
    }
    
    // MARK: - Private Helpers
    private func convertCentsToDollars(val: Int) -> Double {
         return Double(val / 100)
    }
    
    private func displayCentsInDollarsNoDecimal(value: Int) -> String {
        //return String(format: "$%.00f", Double(value / 100))
        return displayDollars(val: convertCentsToDollars(val: value))
    }
    
    private func displayDollars(val: Double) -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.maximumSignificantDigits = 4
        // localize to your grouping and decimal separator
        formatter.locale = Locale.current
        
        return formatter.string(from: NSNumber(value: val))!
    }
}
