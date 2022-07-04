//
//  SignOutViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/1/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class SignOutViewController: BaseViewController {

    @IBOutlet weak var btnSignOut: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        UIUtility.styleButton(btn: btnSignOut, currentVc: self)
        UIUtility.styleSecondaryButton(btn: btnCancel, currentVc: self)
    }
    
    @IBAction func btnSignOutTouch(_ sender: UIButton) {
        AuthUtility.logout()
        UIUtility.goToSignInViewController(currentVc: self, animated: true)
    }
    
    @IBAction func btnCancelTouch(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
    }
}
