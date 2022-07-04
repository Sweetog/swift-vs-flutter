//
//  ContestModel.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/24/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Firebase

struct ContestModel: Codable {
    var id: String?
    var name: String
    var amount: Int?
    var payout: Int
    var payoutLabel: String?
    var startDate: Timestamp?
    var endDate: Timestamp? //prepped for removal in v.1.5, v1.4 has dependency
    var courseId: String?
    var courseModel: CourseModel?
    var contests: [ContestModel]?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case amount
        case payout
        case payoutLabel
        case startDate
        case courseId
        case contests
    }
}
