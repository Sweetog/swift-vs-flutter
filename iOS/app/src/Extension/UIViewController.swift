//
//  UIViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/10/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @objc func addFundsPresenter() {
        if self.navigationController?.visibleViewController is AddFundsViewController { return }
        UIUtility.presentAdFunds(currentVc: self)
    }
    
    func setNavBar() {
        if !AuthUtility.isLoggedIn() { return }
        
        let displayName = (CurrentUser.sharedInstance.displayName != nil) ? CurrentUser.sharedInstance.displayName : CurrentUser.sharedInstance.email
        setNavBar(accountBalance: CurrentUser.sharedInstance.accountBalance, displayName: displayName)
    }
    
    // MARK - Private Helpers
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
    
    private func setNavBar(accountBalance: Int?, displayName: String?) {
        //let navItem = UINavigationItem(title: "")
        
        if !(self.navigationController?.visibleViewController is HomeViewController) {
            //add logo
            let logoNav = UIImage(named: imageNames.navBarLogo)
            let imageView = UIImageView(image: logoNav)
            imageView.contentMode = .scaleAspectFit
            self.navigationItem.titleView = imageView
        }
        
        if self.navigationController?.visibleViewController is AddFundsSuccessViewController {
            self.navigationItem.hidesBackButton = true
        }
        
        let addFundsBarButtonItem = createAddFundsBarButtonItem(accountBalance: CurrentUser.sharedInstance.accountBalance)
        self.navigationItem.rightBarButtonItem = addFundsBarButtonItem
    }
    
    private func createUserBarButtonItem(displayNameNavItem: String) -> UIBarButtonItem {
        return UIBarButtonItem(title: displayNameNavItem, style: UIBarButtonItem.Style.plain, target: self, action: nil)
    }
}
