//
//  CreateAccountViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/31/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import SwiftValidator
import Stripe
class CreateAccountViewController: BaseViewController, UITextViewDelegate, ValidationDelegate {

    @IBOutlet weak var txtProfileName: UITextField!
    @IBOutlet weak var btnCreateAccount: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtViewAgreeTerms: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var switchAm18: UISwitch!
    @IBOutlet weak var lblAm18: UILabel!
    @IBOutlet weak var switchAmAmateur: UISwitch!
    @IBOutlet weak var lblAmateurStatus: UILabel!
    
    var validator: Validator!
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addBackground(imageName: imageNames.bgIphoneGreenPutting)
        self.view.addBackground()
        setEnvironmentVars()
        styleUIComponents()
        
        txtViewAgreeTerms.delegate = self
        txtConfirmPassword.delegate = self
        txtEmail.delegate = self
        switchAm18.isOn = false
        switchAmAmateur.isOn = false
        
        if #available(iOS 12.0, *) {
            txtPassword.passwordRules =  UITextInputPasswordRules(descriptor: "required: digit; max-consecutive: 2; minlength: 8;")
        }
        if #available(iOS 12.0, *) {
            txtConfirmPassword.passwordRules =  UITextInputPasswordRules(descriptor: "required: digit; max-consecutive: 2; minlength: 8;")
        }
        
        //validation
        validator = setValidation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !AuthUtility.accountCreated {
            AuthUtility.logout()
        }
        
        super.viewWillDisappear(animated)
    }

    @IBAction func btnCreateAccountTouch(_ sender: UIButton) {
        validator.validate(self)
    }
    
    // MARK: - ValidationDelegate
    func validationSuccessful() {
        if !switchAm18.isOn {
            UIUtility.popConfirmationAlertOkDismiss(self, title: "Must Be 18", message: "You must be at least 18 years old", dismiss:{})
            return
        }
        
        if !switchAmAmateur.isOn {
            UIUtility.popConfirmationAlertOkDismiss(self, title: "Must Be an Amateur", message: "You must be an amateur as defined by the USGA Rules of Amateur Status", dismiss:{})
            return
        }
        
        beginCreateAccount(displayName: txtProfileName.text!, email: txtEmail.text!, password: txtPassword.text!, isAge18: true)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        print("validationFailed")
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == schemes.PrivacyPolicy {
            print("policy scheme")
        }
        
        if URL.scheme == schemes.Terms{
            print("terms scheme")
        }
        
        if URL.scheme == schemes.Http {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        
        return false
    }
    
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleButton(btn: btnCreateAccount, currentVc: self)
        
        UIUtility.setAgreeTermsTextView(txtView: txtViewAgreeTerms, btnText: btnCreateAccount.currentTitle!)
        
        UIUtility.styleTextField(tf: txtProfileName, placeholderText: "Profile Name")
        UIUtility.styleTextField(tf: txtEmail, placeholderText: "Email")
        UIUtility.styleTextField(tf: txtPassword, placeholderText: "Password")
        UIUtility.styleTextField(tf: txtConfirmPassword, placeholderText: "Confirm Password")
        
        switchAm18.onTintColor = UIColor.primaryForegroundColor
        switchAmAmateur.onTintColor = UIColor.primaryForegroundColor
        UIUtility.styleLabelTitle3(lbl: lblAm18)
        UIUtility.styleLabelTitle3(lbl: lblAmateurStatus)
    }
    
    private func setEnvironmentVars() {
        txtProfileName.text = Environment.configuration(.displayName)
        txtEmail.text = Environment.configuration(.email)
        txtPassword.text = Environment.configuration(.password)
        txtConfirmPassword.text = Environment.configuration(.password)
    }
    
    private func setValidation() -> Validator{
        var tfs = [UITextField]()
        var rules = [[Rule]]()
        
        //profileName
        tfs.append(txtProfileName)
        rules.append([RequiredRule()])
        //email
        tfs.append(txtEmail)
        rules.append([RequiredRule(), EmailRule()])
        //password
        tfs.append(txtPassword)
        rules.append([RequiredRule(), BmsPasswordRule()])
        //confirm password
        tfs.append(txtConfirmPassword)
        rules.append([RequiredRule(), ConfirmPasswordRule(txtPassword: txtPassword)])
        
        return ValidatorUtility.create(tfs:tfs, rules: rules, view: self.view)
    }
    
    private func beginCreateAccount(displayName: String, email: String, password: String, isAge18:Bool) {
        
        self.alert = UIUtility.createAlertBlackSpinner(self, title: "Creating Account")
        
         AuthUtility.firebaseCreateAccount(displayName: displayName, email: email, password: password, isAge18: isAge18) { (error) in
            
            self.alert!.dismiss(animated: true, completion: {
                if let error = error {
                    if let authError = error as? AuthError {
                        if authError == .existingUserCreateAccountAttempt {
                            UIUtility.popConfirmationAlertOkDismiss(self, title: "Existing Member", message: "Existing member for email: \(email)", dismiss: {
                            })
                        }
                    }
                    if ErrorUtility.isHttpErrorCouldNotConnectToServer(error: error) {
                        UIUtility.popConfirmationAlertWithDismissNoButtons(self, title: "Technology Maintenance Outage", message: "Sorry, Please try again in 1 minutes.", displayTime: 3.0, dismiss: {
                            UIUtility.goToSignInViewController(currentVc: self, animated: true)
                        })
                    }
                    return
                }
                
                AuthUtility.accountCreated = true
                
                UIUtility.goToHomeViewController(currentVc: self, animated: true)
            })
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == txtConfirmPassword.tag{
            textField.resignFirstResponder() // Dismiss the keyboard
            return true
        }
    
        return false
    }
}
