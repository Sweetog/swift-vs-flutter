//
//  TermsViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 2/23/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    @IBOutlet weak var txtView: UITextView!
    private let termsFont = UIUtility.fontTitle3
    private var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        self.setNavBar()
        
        styleUIComponents()
        addActivityIndicator()
        getContestRules()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Private Helpers
    private func addActivityIndicator() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    private func styleUIComponents() {
        self.view.backgroundColor = UIColor.secondaryBackgroundColor
        self.txtView.font = termsFont
    }
    
    private func getContestRules() {
        activityIndicator.startAnimating()
        ContentRepository.getById(contentId: "rokR7efNONnA6RwQzQnP") { (contentModel, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                UIUtility.popConfirmationAlertOkDismiss(self, title: "Error Loading", message: error.localizedDescription, dismiss: {})
                return
            }
            
            guard let contentModel = contentModel else {
                return
            }
            
            //set the content
            self.txtView.text = contentModel.text
            self.txtView.contentOffset.y = -100
        }
    }
}
