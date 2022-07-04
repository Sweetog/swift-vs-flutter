//
//  StartViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/5/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class StartViewController: BaseViewController {

    @IBOutlet weak var btnMember: UIButton!
    @IBOutlet weak var btnBecomeMember: UIButton!
    
    let segueSignUpIdentifier = "segueSignUp"
    let segueSignInIdentifier = "segueSignIn"
    var isMember = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground(imageName: imageNames.bgIphoneGreenGoldBall)
        self.view.addBackground()
        styleUIComponents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if AuthUtility.isLoggedIn() {
            UIUtility.goToHomeViewController(currentVc: self, animated: false)
        }
    }
    
    @IBAction func btnSignInTouch(_ sender: UIButton) {
        isMember = true
        performSegue(withIdentifier: segueSignInIdentifier, sender: self)
    }
    
    @IBAction func btnSignUpTouch(_ sender: UIButton) {
        isMember = false
        performSegue(withIdentifier: segueSignUpIdentifier, sender: self)
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleSecondaryButton(btn: btnMember, currentVc: self)
        UIUtility.styleButton(btn: btnBecomeMember, currentVc: self)
    }
}
