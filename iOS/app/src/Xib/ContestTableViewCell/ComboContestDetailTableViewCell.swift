//
//  ComboContestDetailTableViewCell.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 5/5/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class ComboContestDetailTableViewCell: UITableViewCell {
    @IBOutlet var viewContentContainer: UIView!
    @IBOutlet var viewInsetContainer: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblPayout: UILabel!
    @IBOutlet var lblTotalPrizes: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        styleUIComponents()
    }
    
    func setValues(contest: ContestModel, course: CourseModel) {
        lblName.text = contest.name
        
        lblPayout.text = contest.payout.displayCentsInDollarsNoDecimal()
        //lblCourse.text = contest.name
        lblDate.text = "Contest Date -  \(Date().toYearMonthDay())"
        if let payoutLblText = contest.payoutLabel {
            lblTotalPrizes.text = payoutLblText
        }
    }

    private func styleUIComponents() {
        UIUtility.styleLabelTitle1(lbl: lblName)
        UIUtility.styleLabelTitle1(lbl: lblPayout)
        UIUtility.styleLabelCaption(lbl: lblDate)
        UIUtility.styleLabelCaption(lbl: lblTotalPrizes)
        
        lblDate.textColor = UIColor.secondaryForegroundColor
        lblPayout.textColor = UIColor.logoGreen
        lblTotalPrizes.textColor = UIColor.secondaryForegroundColor
        //lblName.textColor = UIColor.logoGreen
        
        viewContentContainer.backgroundColor = UIColor.secondaryBackgroundColor
        viewInsetContainer.backgroundColor = UIColor.clear
        viewInsetContainer.layer.borderColor = UIColor.primaryForegroundColor.cgColor
        viewInsetContainer.layer.borderWidth = UIUtility.defaultBorderWidth
        viewInsetContainer.layer.cornerRadius = UIUtility.defaultCornerRadius
    }
}
