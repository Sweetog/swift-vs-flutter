//
//  UIUtility.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/12/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import Stripe
import AlamofireImage

final class UIUtility {
    // MARK: - defaults
    static let defaultCornerRadius = CGFloat(8.0)
    static let defaultBorderWidth = CGFloat(2.0)
    static let defaultHeightForHeaderSection = CGFloat(6.0)
    static let defaultLargeRowHeight = CGFloat(120.0)
    static let defaultMediumRowHeight = CGFloat(90.0)
    
    private static let lalezarRegular = "Lalezar-Regular" //"ClanPro-NarrBold"
    private static let avianoRegular = "Aviano-Regular"
    
    // MARK: - facebook button
    private static let btnFbHeight = "40"
    
    // MARK: -font sizes
    private static let BannerFontSize = CGFloat(42.0)
    private static let headerFontSize = CGFloat(34.0)
    private static let titleFontSize = CGFloat(29.0)
    private static let title1FontSize = CGFloat(26.0)
    private static let title2FontSize = CGFloat(22.0)
    private static let title3FontSize = CGFloat(19.0)
    private static let captionFontSize = CGFloat(14.0)
    private static let smallFontSize = CGFloat(12.0)
    
    // MARK: - fonts
    private static let fontAvianoBanner = UIFont(name: avianoRegular, size: BannerFontSize)
    private static let fontBanner = UIFont(name: lalezarRegular, size: BannerFontSize)
    private static let fontHeader = UIFont(name: lalezarRegular, size: headerFontSize)
    private static let fontTitle = UIFont(name : lalezarRegular, size: titleFontSize)
    private static let fontTitle1 = UIFont(name : lalezarRegular, size: title1FontSize)
    private static let fontTitle2 = UIFont(name : lalezarRegular, size: title2FontSize)
    static let fontTitle3 = UIFont(name : lalezarRegular, size: title3FontSize)
    static let fontCaption = UIFont(name: lalezarRegular, size: captionFontSize)
    static let fontSmall = UIFont(name: lalezarRegular, size: smallFontSize)
    private static let fontTitleColor = UIColor.primaryForegroundColor
    private static let fontTitleColorAlternate = UIColor.white
    
    // MARK: - TableView Section Header
    private static let fontTableViewSectionTitle = fontTitle3
    private static let fontTableViewSectionTitleColor = UIColor.secondaryForegroundColor
    
    // MARK: - view container
    private static let viewContCornerRadius = defaultCornerRadius
    private static let viewContBgColor = UIColor.secondaryBackgroundColor
    
    // MARK: - logo view container
    private static let viewLogoContCornerRadius = defaultCornerRadius
    private static let viewLogoContBgColor = UIColor.secondaryBackgroundColor
    private static let viewLogoContBorderWidth = CGFloat(0.0)
    private static let viewLogoContBorderColor = UIColor.primaryForegroundColor
    
    // MARK: - pickview & datepicker
    private static let pkHeight = 100
    private static let pkBgColor = UIColor.secondaryBackgroundColor
    private static let pkCornerRadius = defaultCornerRadius
    private static let pkFontColor = UIColor.primaryForegroundColor
    private static let pkFontSize = CGFloat(17.0)
    private static let pkFont = UIFont(name : lalezarRegular, size: pkFontSize)
    
    // MARK: - primary button
    private static let btnHeight = 42
    private static let btnFontColor = UIColor.primaryForegroundColor
    private static let btnBorderColor = UIColor.primaryForegroundColor.cgColor
    private static let btnBgColor = UIColor.verdantGoldBlack
    private static let btnBorderSize = defaultBorderWidth
    private static let btnCornerRadius = defaultCornerRadius
    private static let btnFontSize = CGFloat(20.0)
    private static let btnFont = UIFont(name: lalezarRegular, size: btnFontSize)
    
    // MARK: - call to action button
    private static let btnCallToActionFontSize = CGFloat(22.0)
    private static let btnCallToActionFont = UIFont(name: lalezarRegular, size: btnCallToActionFontSize)
    
    // MARK: - secondary button
    private static let btnSecondaryFontColor = UIColor.primaryForegroundColor
    private static let btnSecondaryBgColor = UIColor.verdantGoldBlack
    private static let btnSecondaryBorderColor = UIColor.primaryForegroundColor.cgColor
    private static let btnSecondaryBorderSize = defaultBorderWidth
    private static let btnSecondaryCornerRadius = defaultCornerRadius
    
    // MARK: - deposit button
    private static let btnDepositFontColor = UIColor.primaryForegroundColor
    private static let btnDepositBorderSize = defaultBorderWidth
    private static let btnDepositBgColor = UIColor.secondaryBackgroundColor
    private static let btnDepositBorderColor = UIColor.primaryForegroundColor.cgColor
    
    // MARK: - text button
    private static let btnTextTintColor = UIColor.secondaryForegroundColor
    
    // MARK: - NavBarButtonItem
    private static let navBarBtnItemFontColor = UIColor.primaryForegroundColor
    private static let navBarBtnItemFont = btnFont
    
    // MARK: - Deposit NavBarButtonItem
    private static let navBarBtnItemDespotFontColor = UIColor.verdantGoldBlack
    private static let navBarBtnItemDepositFontSize = CGFloat(12.0)
    private static let navBarBtnItemDepositFont = UIFont(name: lalezarRegular, size: navBarBtnItemDepositFontSize)
    private static let navBarBtnItemDepositRadius = CGFloat(3.0)
    
   // MARK: - textfield
    private static let txtBgColor = UIColor.lightText
    private static let txtFontColor = UIColor.verdantGoldBlack
    private static let txtFontSize = CGFloat(24.0)
    private static let txtFont = UIFont(name: lalezarRegular, size: txtFontSize)
    private static let txtPlaceholderFont = txtFont
    private static let txtPlaceholderFontColor = UIColor.secondaryBackgroundColor
    
    // MARK: - terms
    private static let termsFontSize = CGFloat(14.0)
    private static let termsFont = UIFont.boldSystemFont(ofSize: termsFontSize)
    private static let termsFontColor = UIColor.veryDarkGray
    private static let linkColor = UIColor.primaryForegroundColor
    
   // MARK: - Stripe
    private static let stripeAccentColor = UIColor.primaryForegroundColor
    private static let stripePrimaryBgColor = UIColor.secondaryBackgroundColor
    private static let stripeSecondaryBgColor = UIColor.veryDarkGray
    private static let primaryFgColor = UIColor.primaryForegroundColor
    private static let secondaryFgColor = UIColor.secondaryForegroundColor
    private static let stripeFontSize = CGFloat(14.0)
    private static let stripeFont = UIFont(name: lalezarRegular, size: stripeFontSize)
    
    static func setStripeTheme() {
        // Stripe theme configuration
        STPTheme.default().accentColor = stripeAccentColor
        STPTheme.default().primaryBackgroundColor = stripePrimaryBgColor
        STPTheme.default().secondaryBackgroundColor = stripeSecondaryBgColor
        STPTheme.default().primaryForegroundColor = primaryFgColor
        STPTheme.default().secondaryForegroundColor = secondaryFgColor
        STPTheme.default().font = stripeFont
        STPTheme.default().emphasisFont = stripeFont
    }
 
    // MARK: - UIImage
    static let defaultImageTransition = UIImageView.ImageTransition.crossDissolve(0.5)
    
    static func setAgreeTermsTextView(txtView: UITextView, btnText: String) {

        let terms = text.SignupAgree.replacingOccurrences(of: text.BtnTextMatch, with: btnText)
        
        let attrs = [NSAttributedString.Key.font: termsFont]
        let attributedString = NSMutableAttributedString(string: terms, attributes: attrs)
        
        if !attributedString.setSubstringAsLink(substring: text.SignupTermsMatch, linkURL: urls.terms) {
            print("failed to find terms text match");
            return
        }
        
        if !attributedString.setSubstringAsLink(substring: text.SignupAgreePrivacyPolicyMatch, linkURL: urls.privacy) {
            print("failed to find Privacy Policy text match");
            return
        }
        
        let linkAttributes = [NSAttributedString.Key.foregroundColor: linkColor, NSAttributedString.Key.font: termsFont]
        txtView.linkTextAttributes = linkAttributes
        txtView.attributedText = attributedString
        txtView.isSelectable = true
        txtView.isEditable = false
        txtView.isUserInteractionEnabled = true
        txtView.textColor = termsFontColor
    }
    
    // MARK: - Navigation/Present
    static func presentAdFunds(currentVc: UIViewController) {
        let storyboard = UIStoryboard(name: storyboardIdentifiers.mainStoryboard, bundle: nil)
        let addFundsVc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifiers.addFundsNavBar) as! BaseNavigationViewController
        currentVc.present(addFundsVc, animated: true, completion: nil)
    }
    
    static func presentContest(currentVc: UIViewController, contestModel: ContestModel) {
        let storyboard = UIStoryboard(name: storyboardIdentifiers.mainStoryboard, bundle: nil)
        let courseNav = storyboard.instantiateViewController(withIdentifier: storyboardIdentifiers.contestNavBar) as! BaseNavigationViewController
        let vc = courseNav.viewControllers.first as! ContestDetailsViewController
        vc.contestModel = contestModel
        currentVc.present(courseNav, animated: true, completion: nil)
    }
    
    static func presentCourseDetails(currentVc: UIViewController, courseId: String) {
        let storyboard = UIStoryboard(name: storyboardIdentifiers.mainStoryboard, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardIdentifiers.courseDetails) as! CourseDetailsViewController
        vc.courseId = courseId
        currentVc.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    static func presentComboContest(currentVc: UIViewController, contestModel: ContestModel) {
        let storyboard = UIStoryboard(name: storyboardIdentifiers.mainStoryboard, bundle: nil)
        let courseNav = storyboard.instantiateViewController(withIdentifier: storyboardIdentifiers.comboContestNavBar) as! BaseNavigationViewController
        let vc = courseNav.viewControllers.first as! ComboContestDetailsViewController
        vc.contest = contestModel
        currentVc.present(courseNav, animated: true, completion: nil)
    }
    
    static func goToPaymentViewController(currentVc: UIViewController, animated: Bool) {
        self.goToViewController(currentVc: currentVc, storyboardId: storyboardIdentifiers.payment, animated: animated)
    }
    
    static func goToHomeViewController(currentVc: UIViewController, animated: Bool) {
        self.goToViewController(currentVc: currentVc, storyboardId: storyboardIdentifiers.homeTabBar, animated: animated)
    }
    
    static func goToSignInViewController(currentVc: UIViewController, animated: Bool) {
        self.goToViewController(currentVc: currentVc, storyboardId: storyboardIdentifiers.signInNavBar, animated: animated)
    }
    
    static func goToCreateAccountViewController(currentVc: UIViewController, currentUser: CurrentUser?, animated: Bool) {
        let storyboard = UIStoryboard(name: storyboardIdentifiers.mainStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardIdentifiers.createAccount) as! CreateAccountViewController
        currentVc.present(controller, animated: animated)
    }
    
    static func getTableBackgroundImageView() -> UIImageView {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let cgRect = CGRect(x: 0, y: 0, width: width, height: height)
        let imageViewBackground = UIImageView(frame: cgRect)
        imageViewBackground.image = UIImage(named: imageNames.bgIphone)
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        return imageViewBackground
    }
    
    // MARK: - Stylers
    static func styleLabelNoData(lbl: UILabel) {
        styleLabelTitle3(lbl: lbl)
        lbl.textColor = UIColor.funZoneRed
        lbl.textAlignment = NSTextAlignment.center
        lbl.isUserInteractionEnabled = true
    }
    
    static func styleTableViewSectionTitle(lbl: UILabel) {
        lbl.font = fontTableViewSectionTitle
        lbl.textColor = fontTableViewSectionTitleColor
    }
    
    static func styleLabelHeader(lbl: UILabel) {
        lbl.font = fontHeader
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelBanner(lbl: UILabel) {
        lbl.font = fontBanner
        lbl.textColor = fontTitleColor
    }
    
    static func styleAvianoBanner(lbl: UILabel) {
        lbl.font = fontAvianoBanner
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelTitle(lbl: UILabel) {
        lbl.font = fontTitle
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelTitle1(lbl: UILabel) {
        lbl.font = fontTitle1
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelTitle2(lbl: UILabel) {
        lbl.font = fontTitle2
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelTitle3Alternate(lbl: UILabel) {
        lbl.font = fontTitle3
        lbl.textColor = fontTitleColorAlternate
    }
    
    static func styleLabelTitle3(lbl: UILabel) {
        lbl.font = fontTitle3
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelCaption(lbl: UILabel) {
        lbl.font = fontCaption
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelSmall(lbl: UILabel) {
        lbl.font = fontSmall
        lbl.textColor = fontTitleColor
    }
    
    static func styleLabelCaptionAlternate(lbl: UILabel) {
        lbl.font = fontCaption
        lbl.textColor = fontTitleColorAlternate
    }
    
    static func styleContainerViewTitleFullWidth(view: UIView) {
        view.backgroundColor = viewContBgColor
    }
    
    static func styleContainerViewTitleRoundedCorners(view: UIView) {
        view.clipsToBounds = true
        view.layer.cornerRadius = viewContCornerRadius
        view.backgroundColor = viewContBgColor
    }
    
    static func styleLogoContainerView(view: UIView) {
        view.layer.cornerRadius = viewLogoContCornerRadius
        view.backgroundColor = viewLogoContBgColor
        view.layer.borderWidth = viewLogoContBorderWidth
        view.layer.borderColor = viewLogoContBorderColor.cgColor
    }

    static func stylePickerViewText(_ s: String) -> NSAttributedString {
        let attrs = [NSAttributedString.Key.foregroundColor: pkFontColor, NSAttributedString.Key.font: pkFont]
        return NSAttributedString(string: s, attributes: attrs)
    }
    
    static func styleDatePicker(pk: UIDatePicker, currentVc: UIViewController) {
        let constraintIdentifier = "pkDate"
        
        pk.setValue(pkFontColor, forKey: "textColor")
        pk.backgroundColor = pkBgColor
        pk.layer.cornerRadius = pkCornerRadius
        pk.layer.masksToBounds = true
        
        currentVc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(pkHeight))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": pk]))
    }
    
    static func stylePickerView(pk: UIPickerView, currentVc: UIViewController) {
        let constraintIdentifier = "pkHeight"
        
        pk.backgroundColor = pkBgColor
        pk.layer.cornerRadius = pkCornerRadius
        pk.layer.masksToBounds = true
    
        currentVc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(pkHeight))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": pk]))
    }
    
    static func styleAppleButton(btn: PKPaymentButton, currentVc: UIViewController){
        let constraintIdentifier = "btnAppleHeight"
        //let widthConstraintIdentifier = "btnAppleHeight"

        
        currentVc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(btnHeight))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": btn]))
        let widthConstraint = NSLayoutConstraint(item: btn, attribute: .width, relatedBy: .equal, toItem: currentVc.view, attribute: .width, multiplier: 0.70, constant: 0.0)
        currentVc.view.addConstraint(widthConstraint)
    }
    
    static func styleBarButtonItem(btn: UIBarButtonItem) {
        btn.setTitleTextAttributes([
            NSAttributedString.Key.font: navBarBtnItemFont!,
            NSAttributedString.Key.foregroundColor: navBarBtnItemFontColor],
                                          for: .normal)
    }
    
    static func styleButtonForBarButtonItem(btn: UIButton) {
        btn.tintColor = navBarBtnItemFontColor
        btn.titleLabel?.font = navBarBtnItemFont
        btn.setTitleColor(navBarBtnItemFontColor, for: UIControl.State.normal)
    }
    
    static func styleButtonForDepositBarButtonItem(btn: UIButton) {
        btn.tintColor = navBarBtnItemDespotFontColor
        btn.titleLabel?.font = navBarBtnItemDepositFont
        btn.setTitleColor(navBarBtnItemDespotFontColor, for: UIControl.State.normal)
        btn.layer.cornerRadius = navBarBtnItemDepositRadius
    }
    
    static func styleButtonNoHeight(btn: UIButton) {
        styleButtonHelper(btn: btn)
    }
    
    static func styleTextBtn(btn: UIButton) {
        btn.tintColor = btnTextTintColor
        btn.setTitleColor(btnTextTintColor, for: .normal)
        btn.titleLabel?.font = btnFont
    }
    
    
    static func styleCallToActionButton(btn: UIButton, currentVc: UIViewController){
        let constraintIdentifier = "btnHeight"
        
        btn.backgroundColor = UIColor.funZoneYellow
        btn.layer.cornerRadius = btnCornerRadius
        btn.tintColor = UIColor.verdantGoldBlack
        btn.titleLabel?.font = btnCallToActionFont
        
        currentVc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(32))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": btn]))
    }
    
    static func styleZakButton(btn: UIButton, currentVc: UIViewController){
        let constraintIdentifier = "btnHeight"
        
        btn.backgroundColor = UIColor.primaryForegroundColor
        btn.layer.cornerRadius = btnCornerRadius
        btn.tintColor = UIColor.zakAppDesign1BtnForegroundColor
        btn.titleLabel?.font = btnFont
      
        currentVc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(btnHeight))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": btn]))
    }
    
    static func styleButton(btn: UIButton, currentVc: UIViewController){
        styleButtonHelper(btn: btn, btnHeight: btnHeight, currentVc: currentVc)
    }
    
    static func styleSecondaryButton(btn: UIButton, currentVc: UIViewController) {
        styleButtonHelper(btn: btn, btnHeight: btnHeight, currentVc: currentVc)
        btn.tintColor = btnSecondaryFontColor
        btn.backgroundColor = btnSecondaryBgColor
        btn.layer.borderWidth = btnSecondaryBorderSize
        btn.layer.cornerRadius = btnSecondaryCornerRadius
        btn.layer.borderColor = btnSecondaryBorderColor
    }
    
    static func styleDepositButton(btn: UIButton) {
        styleButtonHelper(btn: btn)
        
        btn.layer.borderWidth = btnDepositBorderSize
        btn.layer.borderColor = btnDepositBorderColor
        btn.tintColor = btnDepositFontColor
        btn.backgroundColor = btnDepositBgColor
    }
    
    private static func styleButtonHelper(btn: UIButton, btnHeight: Int? = nil, currentVc: UIViewController? = nil) {
        let constraintIdentifier = "btnHeight"
        
        btn.backgroundColor = btnBgColor
        btn.layer.borderWidth = btnBorderSize
        btn.layer.cornerRadius = btnCornerRadius
        btn.layer.borderColor = btnBorderColor
        btn.tintColor = btnFontColor
        btn.titleLabel?.font = btnFont
        
        guard let currentVc = currentVc else {
            return
        }
        
        guard let btnHeight = btnHeight else {
            return
        }
        
        currentVc.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(btnHeight))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": btn]))
    }
    
    static func styleTextField(tf: UITextField, placeholderText: String){
        
        tf.textColor = txtFontColor
        tf.backgroundColor = txtBgColor
        tf.font = txtFont
        tf.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: txtPlaceholderFontColor, NSAttributedString.Key.font: txtPlaceholderFont!])
    }
    
    // MARK: - Alerts
    static func createAlertBlackSpinner(_ viewController: UIViewController, title: String, message: String? = nil) -> UIAlertController {
        //create an alert controller
        let pending = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Accessing alert view backgroundColor :
        pending.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.black
        //create an activity indicator
        let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.style = .whiteLarge
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        viewController.present(pending, animated: true, completion: nil)
        
        return pending
    }
    
    static func popConfirmationAlertOkCancel(_ viewController: UIViewController, btnOkTxt: String, btnCancelTxt: String, title: String, message: String, ok: @escaping () -> Swift.Void, cancel: @escaping () -> Swift.Void) {
        // create the alert
        let alert: UIAlertController? = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert!.addAction(UIAlertAction(title: btnOkTxt, style: .default, handler: { (alertAction) in
            ok()
        }))
        
        alert!.addAction(UIAlertAction(title: btnCancelTxt, style: .default, handler: { (alertAction) in
            cancel()
        }))
        
        // show the alert
        viewController.present(alert!, animated: true, completion: nil)
    }
    
    static func popConfirmationAlertOkDismiss(_ viewController: UIViewController, title: String?, message: String, dismiss: @escaping () -> Swift.Void) {
        // create the alert
        let alert: UIAlertController? = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert!.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            dismiss()
        }))
        
        // show the alert
        viewController.present(alert!, animated: true, completion: nil)
    }
    
    static func popConfirmationAlertOkTimer(_ viewController: UIViewController, title: String, message: String, displayTime: Double? = nil){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
        
        if displayTime != nil {
            let when = DispatchTime.now() + displayTime!
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    static func popConfirmationAlertWithDismissNoButtons(_ viewController: UIViewController, title: String, message: String, displayTime: Double, dismiss: @escaping () -> Swift.Void) {
        // create the alert
        let alert: UIAlertController? = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // show the alert
        viewController.present(alert!, animated: true, completion: nil)
        
        let when = DispatchTime.now() + displayTime
        DispatchQueue.main.asyncAfter(deadline: when){
            alert!.dismiss(animated: true, completion: {
                dismiss()
            })
        }
    }
    
    static func setUpFacebook(vc: FBSDKLoginButtonDelegate, btnFbSignIn: FBSDKLoginButton) {
        btnFbSignIn.delegate = vc
        
        let viewController = vc as! UIViewController
        setFbBtnHeight(btnFbSignIn, superView: viewController.view, constraintIdentifier: "btnFbSignIn")
        
    }
    
    static func phoneNumberFormatUS(replacementString: String?, str: String?, field: UITextField) -> Bool{
        if replacementString == ""{ //BackSpace
            return true
        }else if str!.count < 3{
            if str!.count == 1{
                field.text = "("
            }
        }else if str!.count == 5{
            field.text = field.text! + ") "
        }else if str!.count == 10{
            field.text = field.text! + "-"
        }else if str!.count > 14{
            return false
        }
        
        return true
    }
    
    static func dateMask(replacementString: String?, str: String?, field: UITextField) -> Bool{
        if replacementString == ""{ //BackSpace
            return true
        }else if str!.count == 3{
            field.text = field.text! + "/"
        }else if str!.count == 6{
            field.text = field.text! + "/"
        }else if str!.count > 10{
            return false
        }
        
        return true
    }
    
    // MARK: - Private Helpers
    private static func goToViewController(currentVc: UIViewController, storyboardId: String, animated: Bool){
        let storyboard = UIStoryboard(name: storyboardIdentifiers.mainStoryboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId)
        currentVc.present(controller, animated: animated)
    }
    
    private static func setFbBtnHeight(_ btnFb: UIButton, superView: UIView, constraintIdentifier:String) {
        //Remove fixed constant height constraint for FBSDKLoginButton
        for constraint: NSLayoutConstraint in btnFb.constraints {
            if(constraint.firstAttribute == .height) {
                print("removing constraint")
                btnFb.removeConstraint(constraint)
            }
        }
        
        //add custom height constraint tweaked to look like same height as Google button
        //the default height of the FBSDKLoginButton is 28, the storyboard height contraint must be 28 as well
        //asked question on Stackoverflow about this: http://stackoverflow.com/questions/44091423/fbsdkloginbutton-programmatic-height-constraint-renders-larger-height-than-same - Brian Ogden 5-20-2017
        superView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[\(constraintIdentifier)(\(btnFbHeight))]", options: [], metrics: nil, views: ["\(constraintIdentifier)": btnFb]))
    }
    
    private static func goToTabarItem(viewController: UIViewController?, viewIndex: Int) {
        guard let tb = getTabBar(viewController: viewController) else {
            return
        }
       
        tb.selectedIndex = viewIndex
    }
    
    private static func getTabBar(viewController: UIViewController?) -> UITabBarController?{
        var tabBar: UITabBarController?
        
        guard let vc = viewController else {
            print("failed goToView attempt, viewController is nil")
            return nil
        }
        
        if vc.tabBarController != nil {
            tabBar = vc.tabBarController
        }else{
            if vc is UITabBarController {
                tabBar = vc as? UITabBarController
            }
        }
        
        guard let tb = tabBar else {
            print("failed goToView attempt, viewController is not in UITabBarController stack")
            return nil
        }
        
        return tb
    }
}
