//
//  SignInViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import SwiftValidator

class SignInViewController: BaseViewController, ValidationDelegate{


    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var validator: Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground(imageName: imageNames.bgIphoneGreenPutting)
        self.view.addBackground()
        setEnvironmentVars()
        styleUIComponents()
        validator = setValidation()
    }
    
    @IBAction func btnSignInTouch(_ sender: UIButton) {
       validator.validate(self)
    }
    
    @IBAction func btnForgotPasswordTouch(_ sender: UIButton) {
        validator.validateField(txtEmail){ error in
            if error != nil {
                return
            }
            
            AuthUtility.sendPasswordResetEmail(email: txtEmail.text!) { (resetError) in
                if resetError != nil {
                    UIUtility.popConfirmationAlertOkTimer(self, title: "Password Reset Error", message: "Error: \(resetError!.localizedDescription)")
                }
                
                UIUtility.popConfirmationAlertOkTimer(self, title: "Password Reset Email Sent", message: "Please check your email inbox for a password reset email")
            }
        }
    }
    
    // MARK: - ValidationDelegate
    func validationSuccessful() {
         signIn()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {

    }
    
    // MARK - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleTextField(tf: txtEmail, placeholderText: "Email")
        UIUtility.styleTextField(tf: txtPassword, placeholderText: "Password")
        UIUtility.styleButton(btn: btnSignIn, currentVc: self)
        UIUtility.styleTextBtn(btn: btnForgotPassword)
    }
    
    private func setEnvironmentVars() {
        txtEmail.text = Environment.configuration(.email)
        txtPassword.text = Environment.configuration(.password)
    }
    
    private func setValidation() -> Validator{
        var tfs = [UITextField]()
        var rules = [[Rule]]()
        
        //email
        tfs.append(txtEmail)
        rules.append([RequiredRule(), EmailRule()])
        
        //password
        tfs.append(txtPassword)
        rules.append([RequiredRule(), BmsPasswordRule()])
        
        return ValidatorUtility.create(tfs:tfs, rules: rules, view: self.view)
    }
    
    private func signIn() {
        activityIndicator.startAnimating()
        AuthUtility.firebaseSignIn(email: txtEmail.text!, password: txtPassword.text!) { (error) in
            self.activityIndicator.stopAnimating()
            self.signInCompletionSegue(error: error)
        }
    }
    
    private func signInCompletionSegue(error: Error?) {
        if let error = error {
            if ErrorUtility.isHttpErrorCouldNotConnectToServer(error: error) {
                UIUtility.popConfirmationAlertWithDismissNoButtons(self, title: "Technology Maintenance Outage", message: "Sorry, Please try again in 1 minutes.", displayTime: 3.0, dismiss: {

                })
                return
            }
            UIUtility.popConfirmationAlertOkTimer(self, title: "Incorrect Username or Password", message: error.localizedDescription)
            return
        }
        
        if !AuthUtility.isLoggedIn() || CurrentUser.sharedInstance.uid == nil {
            UIUtility.goToSignInViewController(currentVc: self, animated: true)
            return
        }
        
        AuthUtility.accountCreated = true
        UIUtility.goToHomeViewController(currentVc: self, animated: true)
    }
    
}
