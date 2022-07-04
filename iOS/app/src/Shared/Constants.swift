//
//  Constants.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit

struct imageNames {
    static let navBarCoin = "icon-coin"
    static let navBarLogo = "logo-gold-member-nav"
    static let navBarDeposit = "btn-deposit"
    static let bgIphoneGreenGoldBall = "bg-iphone-green-gold-ball"
    static let bgIphoneGreenPutting = "bg-iphone-green-putting"
    static let bgIphoneGreen = "bg-iphone-green"
    static let bgIphone = "bg-iphone"
    static let iconGolf = "icon-golf"
    static let iconVideo = "icon-video"
    static let iconQrcode = "icon-qrcode"
    static let iconPin = "icon-pin"
    static let iconInfo = "icon-info"
    static let iconApp = "icon-app"
    static let iconChevronRightaccessorIndicator = "icon-chevron-right-accessor-indicator"
}

struct notificationUserInfoKeys {
    static let accountBalance = "accountBalance"
}

struct storyboardIdentifiers {
    static let homeTabBar = "homeTabBar"
    static let signInNavBar = "signInNavBar"
    static let signOut = "signOutVc"
    static let mainStoryboard = "Main"
    static let createAccount = "createAccount"
    static let createAccountSocial = "createAccountSocial"
    static let payment = "payment"
    static let addFundsNavBar = "addFundsNavBar"
    static let contestNavBar = "contestNavBar"
    static let comboContestNavBar = "comboContestNavBar"
    static let courseDetails = "courseDetails"
    static let comboContestDetails = "comboContestDetails"
}

struct tabBarIndexes {
    static let Home = 0
    static let Courses = 1
    static let Account = 2
}

struct schemes {
    static let PrivacyPolicy = "privacypolicy"
    static let Terms = "terms"
    static let Http = "http"
}

struct urls {
    static let terms = "\(schemes.Http)://bigmoneyshot.com/terms"
    static let privacy = "\(schemes.Http)://bigmoneyshot.com/privacy"
    static let contestRules = "\(schemes.Http)://bigmoneyshot.com/contest-rules"
}

struct text {
    private static let PrivacyPolicyTxt = "Big Money Shot Privacy Policy"
    private static let TermsTxt = "Terms of Use"
    private static let BtnText = "btnText"
    static let SignupAgree = "By clicking \"\(BtnText)\", you are indicating that you have read and agree to the \(PrivacyPolicyTxt) and \(TermsTxt)."
    static let SignupAgreePrivacyPolicyMatch = PrivacyPolicyTxt
    static let SignupTermsMatch = TermsTxt
    static let BtnTextMatch = BtnText
}
