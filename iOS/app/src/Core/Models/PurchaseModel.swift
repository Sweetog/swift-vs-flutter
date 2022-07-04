//
//  PurchaseModel.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/4/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Firebase

class PurchaseModel: Codable {
    var id: String?
    var userId: String
    var contest: ContestModel
    var course: CourseModel
    var timestamp: Timestamp
}
