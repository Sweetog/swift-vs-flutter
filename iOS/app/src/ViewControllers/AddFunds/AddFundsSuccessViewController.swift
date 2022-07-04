//
//  AddFundsSuccessViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/24/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

class AddFundsSuccessViewController: BaseViewController {
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTitleContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addBackground()
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(1308)
        styleUIComponents()
    }
    
    @IBAction func btnContinueTouch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleButton(btn: btnContinue, currentVc: self)
        UIUtility.styleLabelTitle1(lbl: lblTitle)
        UIUtility.styleContainerViewTitleRoundedCorners(view: viewTitleContainer)
    }
}
