//
//  BaseNavigationViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import Stripe

class BaseNavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = UIColor.secondaryBackgroundColor
        UINavigationBar.appearance().tintColor = UIColor.primaryForegroundColor
    
        NotificationUtility.addObserverAccountBalanceChange(self, selector: #selector(self.accountBalanceChange))
        
    }
    
    override func setNeedsStatusBarAppearanceUpdate() {
        super.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func signout(sender: UIBarButtonItem){
        print("signout")
        pushSignOutController()
    }
    
     @objc func addFundsPresent() {
        if self.visibleViewController is AddFundsViewController { return }
        UIUtility.presentAdFunds(currentVc: self)
    }
    
    @objc func accountBalanceChange(notification:NSNotification) {
        if let userInfo = notification.userInfo as? [String: Any]
        {
            if let accountBalance = userInfo[notificationUserInfoKeys.accountBalance] as? Int {
                let addFundsBarButtonItem = createAddFundsBarButtonItem(accountBalance: accountBalance)
                self.navigationBar.items![0].rightBarButtonItem = addFundsBarButtonItem
            }
        }
    }
    
    // MARK: - Private Helpers
    private func createAddFundsBarButtonItem(accountBalance: Int?) -> UIBarButtonItem {
        let ab = (accountBalance != nil) ? accountBalance! : 0
        var btnImg:UIImage!
        if ab == 0 {
            btnImg = UIImage(named: imageNames.navBarDeposit)
        }else {
            btnImg = UIImage(named: imageNames.navBarCoin)
        }
        
        return UIBarButtonItem(image: btnImg, title: "  \(ab.displayAccountBalance())", target: self, action: #selector(addFundsPresenter))
    }
    
    private func pushSignOutController() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: storyboardIdentifiers.signOut) as! SignOutViewController
        self.pushViewController(vc, animated: true)
    }
}
