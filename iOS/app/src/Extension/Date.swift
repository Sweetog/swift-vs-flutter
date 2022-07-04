//
//  Date.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/2/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

extension Date {
    func toYearMonthDay() -> String {
        let df = DateFormatter()
        df.dateFormat = "MMM dd yyyy"
        return df.string(from: self)
    }
}
