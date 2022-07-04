//
//  CourseDetailsViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/30/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import AlamofireImage

class ContestDetailsViewController: BaseViewController {
    
    @IBOutlet weak var lblPayoutTitle: UILabel!
    @IBOutlet weak var courseView: CourseView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var viewContest1Container: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTitleContainer: UIView!
    @IBOutlet weak var lblContestName: UILabel!
    @IBOutlet weak var lblPayout: UILabel!
    @IBOutlet weak var viewVideoVerified: UIView!
    @IBOutlet weak var viewMustPlayToday: UIView!
    @IBOutlet weak var lblVideoVerified: UILabel!
    @IBOutlet weak var lblPlayToday: UILabel!
    @IBOutlet weak var imgVideoVerified: UIImageView!
    @IBOutlet weak var imgPlayToday: UIImageView!
    
    private let segueContestPurchaseSuccessIdentifier = "segueContestPurchaseSuccess"
    var contestModel:ContestModel!
    var courseModel:CourseModel!
    var busy = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if contestModel == nil {
            fatalError()
        }
        
        if contestModel.courseModel == nil {
            fatalError()
        }
        
        courseModel = contestModel.courseModel!
        
        self.view.addBackground()
        
        styleUIComponents()
        setDisplay()
    }
    
    @IBAction func btnContinueTouch(_ sender: UIButton) {
    
        guard let amount = contestModel.amount else{
            return
        }
        
        if CurrentUser.sharedInstance.accountBalance == nil || (-1 * CurrentUser.sharedInstance.accountBalance!) < amount {
            UIUtility.popConfirmationAlertOkDismiss(self, title: "No Funds", message: "Please Tap \"Deposit\" Button Above to Add Funds") {
                
            }
            return
        }
        
        if busy {
            return
        }
        
        activityIndicator.startAnimating()
        busy = true
        PurchaseService.sharedInstance.purchase(courseId: courseModel.id!, contestId: contestModel.id!) { (error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                UIUtility.popConfirmationAlertOkDismiss(self, title: "Error", message: error.localizedDescription, dismiss: {})
                self.busy = false
                return
            }
            
            AuthUtility.freshenCurrentUser(completion: { (error) in
                self.busy = false
                if let error = error {
                    UIUtility.popConfirmationAlertOkDismiss(self, title: "Error", message: error.localizedDescription, dismiss: {})
                    return
                }
                
                let userInfo: [String: Any] = [notificationUserInfoKeys.accountBalance: CurrentUser.sharedInstance.accountBalance!]
                NotificationUtility.notifyAccountBalanceChange(userInfo: userInfo)
                
                self.performSegue(withIdentifier: self.segueContestPurchaseSuccessIdentifier, sender: self)
            })
        }
        
    }
    
    @IBAction func btnCancelTouch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Mark: - Private Helpers
    private func styleUIComponents() {
        let lblContestPrizeFontColor = UIColor.logoGreen
        
        UIUtility.styleLabelTitle2(lbl: lblContestName)
        UIUtility.styleLabelTitle2(lbl: lblTitle)
        UIUtility.styleLabelTitle1(lbl: lblPayout)
        UIUtility.styleLabelTitle2(lbl: lblVideoVerified)
        UIUtility.styleLabelTitle2(lbl: lblPlayToday)
        UIUtility.styleLabelCaption(lbl: lblPayoutTitle)
        //lblContestName.textColor = UIColor.verdantGoldBlack
        lblPayout.textColor = lblContestPrizeFontColor
        lblContestName.textColor = lblContestPrizeFontColor
        lblPayoutTitle.textColor = UIColor.secondaryForegroundColor
        
        UIUtility.styleContainerViewTitleFullWidth(view: viewTitleContainer)
        

        UIUtility.styleContainerViewTitleRoundedCorners(view: viewContest1Container)
        UIUtility.styleContainerViewTitleRoundedCorners(view: viewVideoVerified)
        UIUtility.styleContainerViewTitleRoundedCorners(view: viewMustPlayToday)
        
        let imgV = UIImage(named: imageNames.iconVideo)!.withRenderingMode(.alwaysTemplate)
        imgVideoVerified.image = imgV
        imgVideoVerified.tintColor = UIColor.primaryForegroundColor
        
        let imgP = UIImage(named: imageNames.iconGolf)!.withRenderingMode(.alwaysTemplate)
        imgPlayToday.image = imgP
        imgPlayToday.tintColor = UIColor.primaryForegroundColor
        
        UIUtility.styleButton(btn: btnContinue, currentVc: self)
        UIUtility.styleTextBtn(btn: btnCancel)
    }
    
    private func showUIComponents() {
        btnContinue.isHidden = false
        viewTitleContainer.isHidden = false
        viewContest1Container.isHidden = false
    }
    
    private func setDisplay() {
        courseView.setValues(courseModel: courseModel)
        lblContestName.text = "\(contestModel.name)"
        lblPayout.text = "\(contestModel.payout.displayCentsInDollarsNoDecimal())"
        lblTitle.text = "Hole - \(courseModel.hole)    Par - \(courseModel.par)    HDCP - \(courseModel.handicap)"
        
        if let payoutLabel = contestModel.payoutLabel {
            lblPayoutTitle.text = payoutLabel
        }
        
        guard let amount = contestModel.amount else {
            return
        }
        btnContinue.setTitle("Confirm \(amount.displayCentsInDollarsNoDecimal())", for: .normal)
    }
}
