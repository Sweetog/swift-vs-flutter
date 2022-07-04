//
//  AddFundsViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/21/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import SwiftValidator
class AddFundsViewController: BaseViewController, ValidationDelegate {
    @IBOutlet weak var txtOtherAmount: UITextField!
    @IBOutlet weak var btnAmt1: UIButton!
    @IBOutlet weak var btnAmt2: UIButton!
    @IBOutlet weak var btnAmt3: UIButton!
    @IBOutlet weak var btnAmt4: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    let credit1 = -2500
    let credit2 = -5000
    let credit3 = -7500
    let credit4 = -10000
    let selectedBgColor = UIColor.logoGoldMedium
    let selectedTintColor = UIColor.zakAppDesign1BtnForegroundColor
    let segueAddFundsConfirmIdentifier = "segueAddFundsConfirm"
    var selectedCredit = 0
    var validator: Validator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        
        btnAmt1.setTitle(credit1.displayAccountBalanceNoDecimal(), for: .normal)
        btnAmt2.setTitle(credit2.displayAccountBalanceNoDecimal(), for: .normal)
        btnAmt3.setTitle(credit3.displayAccountBalanceNoDecimal(), for: .normal)
        btnAmt4.setTitle(credit4.displayAccountBalanceNoDecimal(), for: .normal)
        
        styleUIComponents()
        styleButtons()
        validator = setValidation()
        
        txtOtherAmount.delegate = self
    }
    
    // MARK: - ValidationDelegate
    func validationSuccessful() {
        guard let value = txtOtherAmount.text else {
            return
        }
        
        guard let valueInt = Int(value.numbersOnly()) else {
            return
        }
        
        selectedCredit = -100 * valueInt
        print("here\(selectedCredit)")
        performSegue(withIdentifier: segueAddFundsConfirmIdentifier, sender: self)
    }
    
    func validationFailed(_ errors: [(Validatable, ValidationError)]) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
             txtOtherAmount.resignFirstResponder()
        }
        super.touchesBegan(touches, with: event)
    }

    @IBAction func btnAmt1Touch(_ sender: UIButton) {
        resetUI()
        styleSelectedBtn(btn: btnAmt1)
        selectedCredit = credit1
    }
    
    @IBAction func btnAmt2Touch(_ sender: UIButton) {
        resetUI()
        styleSelectedBtn(btn: btnAmt2)
        selectedCredit = credit2
    }

    @IBAction func btnAmt3Touch(_ sender: UIButton) {
        resetUI()
        styleSelectedBtn(btn: btnAmt3)
        selectedCredit = credit3
    }
    
    @IBAction func btnAmt4Touch(_ sender: UIButton) {
        resetUI()
        styleSelectedBtn(btn: btnAmt4)
        selectedCredit = credit4
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
        if CurrentUser.sharedInstance.accountBalance != nil && CurrentUser.sharedInstance.accountBalance! != 0 {
            //the user already has funds in their account, allow them to exit
             self.dismiss(animated: true, completion: nil)
        }
        
        //since user does not have money in their account, encourage them
        //to keep adding funds
        UIUtility.popConfirmationAlertOkCancel(self, btnOkTxt: "No Fun For Me", btnCancelTxt: "I Love Fun!", title: "Cancel Deposit", message: "Are you sure you want to miss out on all the fun?", ok: {
            self.dismiss(animated: true, completion: nil)
        }) {
            //cancel
        }
    }
    
    @IBAction func btnContinueTouch(_ sender: UIButton) {
        continueFunding()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddFundsPaymentViewController {
            vc.accountCredit = selectedCredit
        }
    }
    
    // MARK: - Private Helpers
    private func continueFunding() {
        if let otherAmount = txtOtherAmount.text, !otherAmount.isEmpty {
            //other amount is populated, validate
            validator.validate(self)
            return
        }
        
        if selectedCredit == 0 { return }
        performSegue(withIdentifier: segueAddFundsConfirmIdentifier, sender: self)
        return
    }
    
    private func setValidation() -> Validator{
        var tfs = [UITextField]()
        var rules = [[Rule]]()
        
        tfs.append(txtOtherAmount)
        rules.append([MaxAddFundsRule(), MinAddFundsRule()])
        
        return ValidatorUtility.create(tfs:tfs, rules: rules, view: self.view)
    }
    
    private func styleUIComponents() {
        UIUtility.styleTextField(tf: txtOtherAmount, placeholderText: "Other Amount")
        UIUtility.styleButton(btn: btnContinue, currentVc: self)
        UIUtility.styleTextBtn(btn: btnCancel)
    }
    
    private func resetUI() {
        styleButtons()
        txtOtherAmount.text = nil
    }
    
    private func styleButtons() {
        UIUtility.styleDepositButton(btn: btnAmt1)
        UIUtility.styleDepositButton(btn: btnAmt2)
        UIUtility.styleDepositButton(btn: btnAmt3)
        UIUtility.styleDepositButton(btn: btnAmt4)
    }
    
    private func styleSelectedBtn(btn: UIButton) {
        btn.backgroundColor = selectedBgColor
        btn.tintColor = selectedTintColor
    }
}

// MARK: - UITextFieldDelegate
extension AddFundsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == txtOtherAmount.tag {
            guard let txt = textField.text else {
                return true
            }
            
            guard let num = Int(txt) else {
                return true
            }
            
            textField.text = num.displayDollarsNoDecimal()
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType==UIReturnKeyType.go)
        {
            continueFunding()
            return true
        }
        
        if textField.tag == txtOtherAmount.tag {
            textField.resignFirstResponder() // Dismiss the keyboard
            return true
        }
        
        return false
    }
}
