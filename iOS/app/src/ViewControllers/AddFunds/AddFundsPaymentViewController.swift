//
//  ConfirmWagerViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/16/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import Stripe
import FirebaseAnalytics

class AddFundsPaymentViewController: BaseViewController, UITextViewDelegate {

    var accountCredit: Int!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var lblConfirmWager: UILabel!
    @IBOutlet weak var txtViewTerms: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewTitleContainer: UIView!
    
    
    let segueAddFundsSuccessIdentifier = "segueAddFundsSuccess"
    let unwindToLocationsSegueIdentifier = "unwindToLocationsSegue"
    private var alert: UIAlertController?
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    var isApplePay = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        
        LoggerUtility.beginCheckout()
        activityIndicator.startAnimating()
        
        styleUIComponents()
        
        txtViewTerms.delegate = self
        
        lblConfirmWager.text = "Confirm \(accountCredit.displayAccountBalance())"
    }

    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: StripeService.sharedInstance)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
        
    }

    @IBAction func btnConfirmTouch(_ sender: Any) {
        activityIndicator.startAnimating()
        LoggerUtility.checkoutProgress()
        setPaymentContextPaymentAmount(accountCredit: accountCredit)
        paymentContext.requestPayment()
    }
    
    @IBAction func btnCancelTouch(_ sender: Any) {
         self.performSegue(withIdentifier: unwindToLocationsSegueIdentifier, sender: self)
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleButton(btn: btnConfirm, currentVc: self)
        UIUtility.setAgreeTermsTextView(txtView: txtViewTerms, btnText: btnConfirm.currentTitle!)
        UIUtility.styleLabelTitle1(lbl: lblConfirmWager)
        UIUtility.styleContainerViewTitleFullWidth(view: viewTitleContainer)
    }
    
    private func setPaymentContextPaymentAmount(accountCredit: Int) {
        paymentContext.paymentAmount = -1 * accountCredit
    }
    
    private func addApplePayPaymentButtonToView() {
        let paymentButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .white)
        paymentButton.translatesAutoresizingMaskIntoConstraints = false
        paymentButton.addTarget(self, action: #selector(applePayButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(paymentButton)
        
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: -20))
        
        UIUtility.setAgreeTermsTextView(txtView: txtViewTerms, btnText: "Buy with Apple Pay")
        UIUtility.styleAppleButton(btn:paymentButton, currentVc:self)
    }
    
    @objc private func applePayButtonTapped(sender: UIButton) {
        LoggerUtility.checkoutProgress()
        
        paymentContext.paymentAmount = -1 * accountCredit
        paymentContext.requestPayment()
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
}

// MARK: - STPPaymentContextDelegate
extension AddFundsPaymentViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("paymentContextDidChange")
        if !paymentContext.loading {
            activityIndicator.stopAnimating()
            guard let spm = paymentContext.selectedPaymentMethod else {
                paymentContext.presentPaymentMethodsViewController()
                LoggerUtility.addPaymentInfo()
                return
            }
            
            if spm.label == "Apple Pay" {
                isApplePay = true
                btnConfirm.isHidden = true
                addApplePayPaymentButtonToView()
            }else {
                btnConfirm.isHidden = false
            }
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("didFailToLoadWithError")
        dismiss(animated: true)
        UIUtility.popConfirmationAlertOkTimer(self, title: "Payment Error", message: error.localizedDescription)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        StripeService.sharedInstance.completeCharge(paymentResult, amount: self.paymentContext.paymentAmount) { (error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                completion(error)
                return
            }
          
            AuthUtility.freshenCurrentUser(completion: { (error) in
                if let error = error {
                    completion(error)
                    return
                }
                
                let userInfo: [String: Any] = [notificationUserInfoKeys.accountBalance: CurrentUser.sharedInstance.accountBalance!]
                NotificationUtility.notifyAccountBalanceChange(userInfo: userInfo)
                completion(nil)
                self.performSegue(withIdentifier: self.segueAddFundsSuccessIdentifier, sender: self)
            })
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("didFinishWith status")
    }
}
