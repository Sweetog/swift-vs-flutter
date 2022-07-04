//
//  NotificaationUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/24/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation

class NotificationUtility: NSObject {

    private static let notificationAccountBalanceChangeIdentifier = "accountBalanceChange"

    
    // MARK: - Notifies
    static func notifyAccountBalanceChange(userInfo: [AnyHashable: Any]? = nil) {
        notify(notificationAccountBalanceChangeIdentifier, userInfo: userInfo)
    }
    
    // MARK: - Observers
    static func addObserverAccountBalanceChange(_ observer: Any, selector: Selector) {
        addObserver(observer, selector: selector, name: notificationAccountBalanceChangeIdentifier)
    }
    
    // MARK: - Private Functions
    static private func addObserver(_ observer: Any, selector: Selector, name: String) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    static private func notify(_ notificationName: String, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil, userInfo: userInfo)
    }
}
