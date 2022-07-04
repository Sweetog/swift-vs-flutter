//
//  UIColor.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/11/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    //app palette
    static let primaryForegroundColor = UIColor.funZoneYellow
    static let secondaryForegroundColor = UIColor.lightGray
    static let primaryBackgroundColor = UIColor.funZoneLightGreen
    static let secondaryBackgroundColor = UIColor.verdantGoldBlack
    static let accentColor = UIColor.funZoneOrange
    
    //additional colors
    static let prettyDarkGray = UIColor.darkGray //UIColor(netHex: 0x505050)
    static let veryDarkGray = UIColor(netHex: 0x1f2124)
    static let defaultBlue = UIColor(red: 0.0/255.0, green: 122.0/255.0, blue: 255.0/255.0, alpha: 1.0)
    
    //logo eye drops, logoGoldMedium is from old darker BMS logo
    static let logoGreen = UIColor(netHex: 0x2bb673)
    static let logoGoldMedium = UIColor(netHex: 0xe3be5d)

    //funZone branding palette
    static let funZoneGreen = UIColor(netHex: 0x589e86)
    static let funZoneLightGreen = UIColor(netHex: 0xa0c281)
    static let funZoneYellow = UIColor(netHex: 0xfdd87f)
    static let funZoneOrange = UIColor(netHex: 0xf47e31)
    static let funZoneDarkBlue = UIColor(netHex: 0x233d4d)
    static let funZoneRed = UIColor(netHex: 0xb44647)
    
    //verdantGold branding palette
    static let verdantGoldBlack = UIColor(netHex: 0x040706)

    static let zakWarmBlack = UIColor(netHex: 0x041017)
    
    //zakFirstAppDesign
    static let zakAppDesign1BtnBg = UIColor(netHex: 0xf3de74)
    static let zakAppDesign1BtnForegroundColor = UIColor(netHex: 0x675f3d)
    static let zakAppDesignCourseDetailsBg = UIColor(netHex: 0xecf3f1)
}
