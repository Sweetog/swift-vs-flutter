//
//  NSMutableAttributedString.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/5/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    // Set part of string as URL
    public func setSubstringAsLink(substring: String, linkURL: String) -> Bool {
        let range = self.mutableString.range(of: substring)
        if range.location != NSNotFound {
            self.addAttribute(NSAttributedString.Key.link, value: linkURL, range: range)
            return true
        }
        return false
    }
}
