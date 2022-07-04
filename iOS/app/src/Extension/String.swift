//
//  String.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/11/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//
import Foundation

extension String {
    func numbersOnly() -> String {
        let allowedCharactersSet = NSMutableCharacterSet.decimalDigit()
        return self.components(separatedBy: allowedCharactersSet.inverted).joined(separator: "")
    }
}
