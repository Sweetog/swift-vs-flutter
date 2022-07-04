//
//  IntitializeViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/25/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class InitializeViewController: BaseViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        styleUIComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !AuthUtility.isLoggedIn() {
            UIUtility.goToSignInViewController(currentVc: self, animated: true)
            return
        }
        
        //freshen up Current User
        AuthUtility.freshenCurrentUser { (error) in
            if error != nil {
                if let authError = error as? AuthError {
                    if authError == AuthError.notLoggedIn {
                        UIUtility.goToSignInViewController(currentVc: self, animated: true)
                        return
                    }
                }
                
                AuthUtility.logout()
                UIUtility.goToSignInViewController(currentVc: self, animated: true)
            }
            
            //successfully freshened up CurrentUser
            UIUtility.goToHomeViewController(currentVc: self, animated: true)
        }
    }
    
    private func styleUIComponents() {
        UIUtility.styleLabelTitle3(lbl: lblTitle)
    }
}
