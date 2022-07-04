//
//  ClaimViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/14/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import SwiftValidator

class ClaimViewController: BaseViewController, ValidationDelegate {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtTimeOfDay: UITextField!
    @IBOutlet weak var txtMobilePhone: UITextField!
    @IBOutlet weak var lblTimeOfDay: UILabel!
    @IBOutlet weak var lblMobilePhone: UILabel!
    
    private let courses = ["Fairmont Grand Del Mar", "Torrey Pines"]
    private let contests = ["Birdie", "Sandy Par", "Hole In One"]
    private var busy = false
    private var validator:Validator!
    var purchaseId:String!
    var comboContest:ContestModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if purchaseId == nil {
            fatalError()
        }
        
        self.view.addBackground()
        
        
        txtMobilePhone.delegate = self
        txtTimeOfDay.delegate = self
        
        validator = setValidation()
        styleUIComponents()

    }
    
    // MARK: - ValidationDelegate
    func validationSuccessful() {
        lblMobilePhone.isHidden = false
        lblTimeOfDay.isHidden = false
        createClaim()
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
        lblMobilePhone.isHidden = true
        lblTimeOfDay.isHidden = true
    }
    
    @IBAction func btnContinue(_ sender: UIButton) {
        if busy {
            return
        }
        validator.validate(self)
    }
    
    // MARK: - Private Helpers
    private func setValidation() -> Validator{
        var tfs = [UITextField]()
        var rules = [[Rule]]()
        
        //profileName
        tfs.append(txtTimeOfDay)
        rules.append([RequiredRule()])
        //email
        tfs.append(txtMobilePhone)
        rules.append([RequiredRule(), PhoneRule()])
        
        return ValidatorUtility.create(tfs:tfs, rules: rules, view: self.view)
    }
    
    private func createClaim() {
        busy = true
        activityIndicator.startAnimating()

        if comboContest != nil {
            ClaimService.sharedInstance.claimCombo(purchaseId: purchaseId, time: txtTimeOfDay.text!, phone: txtMobilePhone.text!, comboContestName: comboContest!.name, comboContestPayout: comboContest!.payout) { (error) in
                self.handleClaimComplete(error: error)
            }
            return
        }
        
        ClaimService.sharedInstance.claim(purchaseId: purchaseId, time: txtTimeOfDay.text!, phone: txtMobilePhone.text!) { (error) in
            self.handleClaimComplete(error: error)
        }
    }
    
    private func handleClaimComplete(error:Error?) {
        self.busy = false
        self.activityIndicator.stopAnimating()
        if error != nil {
            UIUtility.popConfirmationAlertOkTimer(self, title: "Error Sending Claim", message: error!.localizedDescription)
            return
        }
        
        var message = "Your claim has been successfully received but you have not provided an email address so that we can contact you with next steps. Please contact us."
        
        if let email = CurrentUser.sharedInstance.email {
            message = "We have successfully received your claim and have started processing! Status updates will be pushed to your app and email address: \(email)"
        }
        
        UIUtility.popConfirmationAlertOkDismiss(self, title: "Claim Prize Intiated", message: message, dismiss: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    private func styleUIComponents() {
        UIUtility.styleLabelTitle3(lbl: lblTimeOfDay)
        UIUtility.styleLabelTitle3(lbl: lblMobilePhone)
        UIUtility.styleTextField(tf: txtTimeOfDay, placeholderText: "Time of Day")
        UIUtility.styleTextField(tf: txtMobilePhone, placeholderText: "Mobile Phone")
        UIUtility.styleButton(btn: btnContinue, currentVc: self)
    }

}

extension ClaimViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if textField.tag == txtMobilePhone.tag{
            
            return UIUtility.phoneNumberFormatUS(replacementString: string, str: str, field: txtMobilePhone)
            
        }else{
            
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag != txtMobilePhone.tag{
            return false
        }
        
        textField.resignFirstResponder() // Dismiss the keyboard
        // Execute additional code
        createClaim()
        return true
    }
}
