//
//  UIButton.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/31/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

extension UIButton {
    @objc func drawShadow(shadowColor: UIColor = UIColor.black, opacity: Float =
        0.3, offset: CGSize, radius: CGFloat = 5, shouldRasterize : Bool = false) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = shouldRasterize
    }
}
