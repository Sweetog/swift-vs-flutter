//
//  ConfirmPasswordRule.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/9/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import SwiftValidator

class ConfirmPasswordRule: Rule {
    private var _txtPassword: UITextField!
    
    func validate(_ value: String) -> Bool {
        return _txtPassword.text == value
    }
    
    func errorMessage() -> String {
        return "Does not match password"
    }
    
    init(txtPassword: UITextField) {
        self._txtPassword = txtPassword
    }
}
