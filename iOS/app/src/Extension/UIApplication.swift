//
//  UIApplication.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/10/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var visibleViewController: UIViewController? {
        
        guard let rootViewController = keyWindow?.rootViewController else {
            return nil
        }
        
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
