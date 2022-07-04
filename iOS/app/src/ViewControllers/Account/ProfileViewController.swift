//
//  ProfileViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/30/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import SwiftValidator

class ProfileViewController: BaseViewController, ValidationDelegate {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var txtProfileName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCreatedDate: UITextField!
    @IBOutlet weak var txtLastLogin: UITextField!
    @IBOutlet weak var lblProfileName: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAccountCreatedDate: UILabel!
    @IBOutlet weak var lblLastLoggedInDate: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var validator: Validator!
    
    override func viewDidLoad() {
        self.view.addBackground()
        
        styleUIComponents()
        setProfileData()
        
        //validation
        validator = setValidation()
    }
    
    @IBAction func btnContinueTouch(_ sender: UIButton) {
         validator.validate(self)
    }
    
    // MARK: - ValidationDelegate
    func validationSuccessful() {
        if txtProfileName.text != CurrentUser.sharedInstance.displayName {
            updateProfile()
        }
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    }
    
    // Mark: - Private Helpers
    private func updateProfile() {
        activityIndicator.startAnimating()
        AuthUtility.updateFirebaseProfile(displayName: txtProfileName.text!, completion: { (error) in
            self.activityIndicator.stopAnimating()
            if error != nil {
                UIUtility.popConfirmationAlertWithDismissNoButtons(self, title: "Update Error", message: "\(error!.localizedDescription)", displayTime: 3.0, dismiss: {
                })
                return
            }
            
            UIUtility.popConfirmationAlertWithDismissNoButtons(self, title: "Success", message: "Profile Name Updated", displayTime: 1.0, dismiss: {
                self.navigationController?.popViewController(animated: true)
            })
        })
    }
    
    private func styleUIComponents() {
        UIUtility.styleLabelTitle3(lbl: lblProfileName)
        UIUtility.styleLabelTitle3(lbl: lblEmail)
        UIUtility.styleLabelTitle3(lbl: lblAccountCreatedDate)
        UIUtility.styleLabelTitle3(lbl: lblLastLoggedInDate)
        
        UIUtility.styleTextField(tf: txtProfileName, placeholderText: "")
        UIUtility.styleTextField(tf: txtEmail, placeholderText: "")
        UIUtility.styleTextField(tf: txtCreatedDate, placeholderText: "")
        UIUtility.styleTextField(tf: txtLastLogin, placeholderText: "")
        //UIUtility.styleContainerViewTitleRoundedCorners(view: viewContainer)
        UIUtility.styleButton(btn: btnContinue, currentVc: self)
    }
    
    private func setProfileData() {
        txtProfileName.text = CurrentUser.sharedInstance.displayName
        let accountCreated = AuthUtility.creationDate()!
        let lastSignIn = AuthUtility.lastSignInDate()!
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        txtCreatedDate.text = format.string(from: accountCreated)
        txtLastLogin.text = format.string(from: lastSignIn)
        txtEmail.text = CurrentUser.sharedInstance.email
    }
    
    private func setValidation() -> Validator{
        var tfs = [UITextField]()
        var rules = [[Rule]]()
        
        //first name
        tfs.append(txtProfileName)
        rules.append([RequiredRule()])

        
        return ValidatorUtility.create(tfs:tfs, rules: rules, view: self.view)
    }
}
