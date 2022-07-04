//
//  ContestTableViewCell.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/1/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class ContestTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCourse: UILabel!
    @IBOutlet weak var lblPayout: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewContentContainer: UIView!
    @IBOutlet weak var btnEnter: UIButton!
    @IBOutlet weak var viewInsetContainer: UIView!
    @IBOutlet weak var lblTotalPrizes: UILabel!
    @IBOutlet weak var imgInfo: UIImageView!
    
    private let btnEnterYConstraintIdentifier = "btnEnterYConstraint"
    private let lblCourseTopContraintIdentifier = "lblCourseTopContraint"
    private let btnEnterWidthConstraintIdentifier = "btnEnterWidthConstraint"
    private let btnEnterWidthForPurchase = CGFloat(110)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleUIComponents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValues(contest: ContestModel) {
        guard let course = contest.courseModel else {
            return
        }
        lblName.text = contest.name
        lblPayout.text = contest.payout.displayCentsInDollarsNoDecimal()
        lblCourse.text = "\(course.name) - Hole \(course.hole)"
        lblDate.text = "Contest Date -  \(Date().toYearMonthDay())"
        if let payoutLblText = contest.payoutLabel {
            lblTotalPrizes.text = payoutLblText
        }
        guard let amount = contest.amount else {
            return
        }
        btnEnter.setTitle("Entry \(amount.displayCentsInDollarsNoDecimal())", for: .normal)
    }
    
    func setValuesCourseDetailsView(contest: ContestModel) {
        guard let course = contest.courseModel else {
            return
        }
        
        setValuesCourseDetails(contest: contest, course: course)
    }
    
    func setValuesComboPurchase(purchase: PurchaseModel, contest: ContestModel) {
        let course = purchase.course
        
        for constraint in btnEnter.constraints {
            if constraint.identifier == btnEnterWidthConstraintIdentifier {
                constraint.constant = btnEnterWidthForPurchase
            }
        }
        
        viewInsetContainer.layoutIfNeeded()
        lblName.text = contest.name
        lblPayout.text = contest.payout.displayCentsInDollarsNoDecimal()
        UIUtility.styleLabelTitle2(lbl: lblPayout)
        lblPayout.textColor = UIColor.logoGreen
        if let payoutLblText = contest.payoutLabel {
            lblTotalPrizes.text = payoutLblText
        }
        
        lblCourse.text = "\(course.name) - Hole \(course.hole)"
        lblDate.text = "Purchase Date -  \(purchase.timestamp.dateValue().toYearMonthDay())"
        btnEnter.setTitle("Claim Prize", for: .normal)
    }
    
    func setValues(purchase: PurchaseModel) {
        let contest = purchase.contest
        let course = purchase.course
        
        for constraint in btnEnter.constraints {
            if constraint.identifier == btnEnterWidthConstraintIdentifier {
                constraint.constant = btnEnterWidthForPurchase
            }
        }
        
        viewInsetContainer.layoutIfNeeded()
        lblName.text = contest.name
        lblPayout.text = contest.payout.displayCentsInDollarsNoDecimal()
        UIUtility.styleLabelTitle2(lbl: lblPayout)
        lblPayout.textColor = UIColor.logoGreen
        if let payoutLblText = contest.payoutLabel {
           lblTotalPrizes.text = payoutLblText
        }
        lblCourse.text = "\(course.name) - Hole \(course.hole)"
        lblDate.text = "Purchase Date -  \(purchase.timestamp.dateValue().toYearMonthDay())"
        btnEnter.setTitle("Claim Prize", for: .normal)
    }
    
    // MARK: - Private Helpers
    private func setValuesCourseDetails(contest: ContestModel, course: CourseModel) {
        lblName.text = nil
        lblCourse.text = nil
        
        lblCourse.text = contest.name
        
        UIUtility.styleLabelTitle2(lbl: lblCourse)
        lblCourse.textColor = UIColor.logoGreen
        
        for constraint in viewInsetContainer.constraints {
            if constraint.identifier == btnEnterYConstraintIdentifier {
                constraint.constant = 0
            }
            
            if constraint.identifier == lblCourseTopContraintIdentifier {
                constraint.constant = 8
            }
        }
        viewInsetContainer.layoutIfNeeded()
        
        lblPayout.text = contest.payout.displayCentsInDollarsNoDecimal()
        //lblCourse.text = contest.name
        lblDate.text = "Contest Date -  \(Date().toYearMonthDay())"
        if let payoutLblText = contest.payoutLabel {
            lblTotalPrizes.text = payoutLblText
        }
        
        guard let amount = contest.amount else {
            return
        }
        btnEnter.setTitle("Entry \(amount.displayCentsInDollarsNoDecimal())", for: .normal)
    }
    
    private func styleUIComponents() {
        UIUtility.styleLabelTitle3(lbl: lblCourse)
        UIUtility.styleLabelTitle3(lbl: lblName)
        UIUtility.styleLabelTitle1(lbl: lblPayout)
        UIUtility.styleLabelCaption(lbl: lblDate)
        UIUtility.styleLabelCaption(lbl: lblTotalPrizes)
        UIUtility.styleButtonNoHeight(btn: btnEnter)
        
        imgInfo.image = UIImage(named: imageNames.iconInfo)!.withRenderingMode(.alwaysTemplate)
        imgInfo.tintColor = UIColor.primaryForegroundColor
        
        btnEnter.layer.borderWidth = CGFloat(0.0)
        btnEnter.backgroundColor = UIColor.primaryForegroundColor
        btnEnter.setTitleColor(UIColor.verdantGoldBlack, for: .normal)
        
        lblDate.textColor = UIColor.secondaryForegroundColor
        lblPayout.textColor = UIColor.logoGreen
        lblTotalPrizes.textColor = UIColor.secondaryForegroundColor
        lblName.textColor = UIColor.logoGreen
        
        viewContentContainer.backgroundColor = UIColor.secondaryBackgroundColor
        viewInsetContainer.backgroundColor = UIColor.clear
        viewInsetContainer.layer.borderColor = UIColor.primaryForegroundColor.cgColor
        viewInsetContainer.layer.borderWidth = UIUtility.defaultBorderWidth
        viewInsetContainer.layer.cornerRadius = UIUtility.defaultCornerRadius
    }
}
