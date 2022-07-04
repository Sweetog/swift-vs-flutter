//
//  LogoView.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class LogoView: UIView {
    let kCONTENT_XIB_NAME = "LogoView"
    @IBOutlet var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        containerView.fixInView(self)
        UIUtility.styleLogoContainerView(view: containerView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

