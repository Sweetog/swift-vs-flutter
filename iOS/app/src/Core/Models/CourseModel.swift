//
//  CourseModel.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/24/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

class CourseModel: Codable {
    var id: String?
    var imageUrl: URL?
    var handicap: Int
    var hole: Int
    var name: String
    var par: Int
    var logoUrl: URL?
}
