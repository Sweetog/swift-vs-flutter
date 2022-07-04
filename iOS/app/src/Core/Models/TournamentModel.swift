//
//  TournamentModel.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/10/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import Firebase

struct TournamentModel: Codable {
    var name: String?
    var startDate: Timestamp?
    var endDate: Timestamp?
}

