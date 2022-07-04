//
//  LoggerUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/16/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import FirebaseAnalytics

struct LoggerUtility {
    static func addPaymentInfo() {
        if !shouldLog() { return }
        let params = commonParameters()
        Analytics.logEvent(AnalyticsEventAddPaymentInfo, parameters: params)
    }
    
    static func presentOffer() {
        if !shouldLog() { return }
        let params = commonParameters()
        Analytics.logEvent(AnalyticsEventPresentOffer, parameters: params)
    }
    
    static func beginCheckout() {
        if !shouldLog() { return }
        let params = commonParameters()
        Analytics.logEvent(AnalyticsEventBeginCheckout, parameters: params)
    }
    
    static func checkoutProgress(checkoutStep: String? = nil) {
        if !shouldLog() { return }
        var params = commonParameters()
        if checkoutStep != nil {
            params[AnalyticsParameterCP1] = checkoutStep
        }
        Analytics.logEvent(AnalyticsEventCheckoutProgress, parameters: params)
    }
    
    static func paymentComplete() {
        if !shouldLog() { return }
        let params = commonParameters()
        Analytics.logEvent(AnalyticsEventEcommercePurchase, parameters: params)
    }
    
    private static func shouldLog() -> Bool {
        return Environment.isProduction()
    }
    
    private static func commonParameters() -> Dictionary<String, Any> {
        return Dictionary<String, Any>()
    }
}
