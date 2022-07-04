//
//  BaseViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/14/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        self.setNavBar()
    }
    
    //override func v
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
