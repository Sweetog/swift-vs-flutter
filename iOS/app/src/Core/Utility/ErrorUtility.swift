//
//  ErrorUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/29/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//
import Foundation

struct ErrorUtility {
    
    static func isHttpErrorCouldNotConnectToServer(error: Error) -> Bool {
        return isErrorCode(error: error, errorCodeToTest: -1004)
    }
    
    private static func isErrorCode(error: Error, errorCodeToTest: Int) -> Bool {
        let errorCode = (error as NSError).code
        
        return errorCode == errorCodeToTest
    }
}
