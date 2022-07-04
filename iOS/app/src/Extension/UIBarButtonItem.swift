//
//  File.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/20/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    convenience init(image :UIImage, title :String, target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIUtility.styleButtonForBarButtonItem(btn: button)
        
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }

        self.init(customView: button)
    }
    
   convenience init(title :String, target: Any?, action: Selector?) {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        UIUtility.styleButtonForDepositBarButtonItem(btn: button)
        button.backgroundColor = UIColor.logoGreen
        if let target = target, let action = action {
            button.addTarget(target, action: action, for: .touchUpInside)
        }
        
        self.init(customView: button)
    }
    
    func addTargetForAction(target: AnyObject, action: Selector) {
        self.target = target
        self.action = action
    }
}
