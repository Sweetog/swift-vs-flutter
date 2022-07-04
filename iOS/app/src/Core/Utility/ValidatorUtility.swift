//
//  ValidateUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 1/1/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import SwiftValidator

let passwordMinLength = 6

struct ValidatorUtility {
    private static let errorLblFontSize = CGFloat(15.0)
    
    static func create(tfs: [UITextField], rules: [[Rule]], view: UIView) -> Validator {
        let validator = Validator()
        
        if tfs.count != rules.count {
            print("unbalanced textfields and rules!!, validator cannot be created")
        }
        
        for (index, tf) in tfs.enumerated() {
            let r = rules[index]
            let lbl = createErrorLabel(view: view)
            let e = constrainLabelToTextField(lbl: lbl, tf: tf, view: view)
            validator.registerField(tf, errorLabel: e, rules: r)
        }
        
        validator.styleTransformers(success: {
            (validationRule) -> Void in
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.clear.cgColor
                textField.layer.borderWidth = 0
            }
            
            if let errorLabel = validationRule.errorLabel {
                errorLabel.text = nil
                errorLabel.isHidden = true
            }
            
        }, error:  {
            (validationError) -> Void in
            if let field = validationError.field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
    
            if let errorLabel = validationError.errorLabel {
                errorLabel.text = validationError.errorMessage
                errorLabel.isHidden = false
            }
        })
        
        return validator
    }
    
    static func reset(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                UIUtility.styleTextField(tf: field, placeholderText: field.placeholder!)
            }
            
            error.errorLabel?.text = nil
            error.errorLabel?.isHidden = true
        }
    }
    
    static func validate(_ errors: [(Validatable, ValidationError)]) {
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            }
            
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.isHidden = false
        }
    }
    
    private static func constrainLabelToTextField(lbl: UILabel, tf: UITextField, view: UIView) -> UILabel {
        let bottomSpace = NSLayoutConstraint(item: tf, attribute: .top, relatedBy: .equal, toItem: lbl, attribute: .bottom, multiplier: 1.0, constant: 0)
        let leading = NSLayoutConstraint(item: lbl, attribute: .leading, relatedBy: .equal, toItem: tf, attribute: .leading, multiplier: 1.0, constant: 0)

        view.addConstraint(bottomSpace)
        view.addConstraint(leading)
        
        return lbl
    }
    
    private static func createErrorLabel(view: UIView) -> UILabel {
        let e = UILabel()
        e.font = UIFont.systemFont(ofSize: errorLblFontSize)
        e.textColor = UIColor.red
        e.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(e)
        return e
    }
}

