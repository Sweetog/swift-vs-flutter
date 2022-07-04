//
//  CollectionReference.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/2/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import FirebaseFirestore

extension CollectionReference {
    func whereField(_ field: String, isDateInToday value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
            else {
                fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
    
    func whereField(_ field: String, isDateIn30Days value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 30, to: start)
            else {
                fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
    
    func whereField(_ field: String, isDateInLast30Days value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: -30, to: start)
            else {
                fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: end).whereField(field, isLessThan: start)
    }
}
