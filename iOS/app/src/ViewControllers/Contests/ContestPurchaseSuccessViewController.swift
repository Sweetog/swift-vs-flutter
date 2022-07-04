//
//  ContestPurchaseSuccessViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/31/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import AudioToolbox
class ContestPurchaseSuccessViewController: BaseViewController {
    
    @IBOutlet weak var viewTitleContainer: UIView!
    @IBOutlet weak var viewInstructContainer: UIView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblnstruct: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(1308)
        styleUIComponents()
    }
    
    @IBAction func btnContinueTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleLabelTitle3(lbl: lblTitle)
        UIUtility.styleLabelTitle3(lbl: lblnstruct)
        UIUtility.styleContainerViewTitleRoundedCorners(view: viewTitleContainer)
        UIUtility.styleContainerViewTitleRoundedCorners(view: viewInstructContainer)
        UIUtility.styleButton(btn: btnContinue, currentVc: self)
    }
}
