//
//  Error.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import Foundation

enum AuthError: Error {
    case notLoggedIn
    case tokenNil
    case existingUserCreateAccountAttempt
    case userDoesNotExist
}

enum DatabaseError: Error {
    case decode
    case userGet
    case notExist
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notLoggedIn:
            return NSLocalizedString("The CurrentUser is nil", comment: "CurrentUser nil")
        case .tokenNil:
            return NSLocalizedString("The Firebase Token is nil", comment: "Firebase Token nil")
        case .existingUserCreateAccountAttempt:
            return NSLocalizedString("Attempt to create an email account for an existing user", comment: "Attempt to create an email account for an existing user")
        case .userDoesNotExist:
            return NSLocalizedString("User Does Not Exist", comment: "The user uid does not seem to exist in the database")
        }
    }
}

extension DatabaseError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decode:
            return NSLocalizedString("Decoding Error", comment: "Could not decode database values to Model representation")
        case .userGet:
            return NSLocalizedString("User Get Database Error", comment: "Current value in database is not out of sync with current user activity")
        case .notExist:
            return NSLocalizedString("Resource Does Not Exist", comment: "For the given id, the resource does not exist")
        }
    }
}
