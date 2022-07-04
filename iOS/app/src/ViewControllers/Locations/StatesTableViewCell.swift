//
//  StatesTableViewCell.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/25/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class StatesTableViewCell: UITableViewCell {


    @IBOutlet weak var imgState: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        styleUIComponents()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleLabelHeader(lbl: lblName)
        self.backgroundColor = UIColor.clear
        viewContainer.backgroundColor = UIColor.secondaryBackgroundColor
        viewContainer.layer.borderColor = UIColor.funZoneYellow.cgColor
        viewContainer.layer.borderWidth = UIUtility.defaultBorderWidth
        viewContainer.layer.cornerRadius = UIUtility.defaultCornerRadius
    }
}
