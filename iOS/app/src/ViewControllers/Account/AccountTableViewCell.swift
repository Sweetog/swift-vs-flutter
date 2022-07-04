//
//  AccountTableViewCell.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = .zero
        self.layoutMargins = .zero
        self.backgroundColor = UIColor.primaryForegroundColor
        self.contentView.backgroundColor = UIColor.secondaryBackgroundColor

        let chevron = UIImage(named: imageNames.iconChevronRightaccessorIndicator)
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: chevron!)
        
        UIUtility.styleLabelTitle3(lbl: lblTitle)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    func select() {
        self.contentView.backgroundColor = UIColor.primaryForegroundColor
    }
    
    func deSelect() {
        self.contentView.backgroundColor = UIColor.secondaryBackgroundColor
        self.backgroundColor = UIColor.primaryForegroundColor
        self.selectionStyle = .none
    }
}
