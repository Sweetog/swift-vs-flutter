//
//  AccountViewController2.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/30/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import Stripe

class AccountViewController: BaseViewController {
    

    @IBOutlet weak var tblViewAccount: UITableView!
    @IBOutlet weak var viewProfileContainer: UIView!
    @IBOutlet weak var viewProfileLetter: UIView!
    @IBOutlet weak var lblProfileLetter: UILabel!
    @IBOutlet weak var lblDisplayName: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!
    
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    private let accountCellIdentifier = "accountCell"
    private let segueClaimIdentifier = "segueClaim"
    private let segueTermsIdentifier = "segueTerms"
    private let segueLogoutIdentifier = "segueLogout"
    private let segueProfileIdentifier = "segueProfile"
    private let seguePurchaseHistoryIdentifier = "seguePurchaseHistory"
    private var accountSections:[sectionModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AuthUtility.isLoggedIn() {
            fatalError()
        }
        
        tblViewAccount.backgroundView = UIUtility.getTableBackgroundImageView()
        tblViewAccount.delegate = self
        tblViewAccount.dataSource = self
        
        //adding an invisible footer so that UIKit will NOT fill empty space below the rows in the table with empty row
        tblViewAccount.tableFooterView = UIView(frame: .zero)
        
        styleUIComponents()
        
        accountSections = createAccountOptions()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleViewProfileContainerTap(sender:)))
        viewProfileContainer.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleViewProfileContainerTap(sender: UITapGestureRecognizer) {
         performSegue(withIdentifier: segueProfileIdentifier, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProfileData()
        tblViewAccount.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customerContext.clearCachedCustomer()
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: StripeService.sharedInstance)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    // Mark: - Private Helpers
    private func setProfileData() {
        lblProfileLetter.text = String(CurrentUser.sharedInstance.displayName!.first!).uppercased()
        lblDisplayName.text = CurrentUser.sharedInstance.displayName
        let date = AuthUtility.creationDate()!
        let format = DateFormatter()
        format.dateFormat = "yyyy"
        let formattedDate = format.string(from: date)
        lblMemberSince.text = "Member Since \(formattedDate)"
    }
    
    private func styleUIComponents() {
        viewProfileLetter.layer.cornerRadius = viewProfileLetter.frame.size.width/2
        viewProfileLetter.clipsToBounds = true
        viewProfileLetter.backgroundColor = UIColor.primaryForegroundColor
        viewProfileContainer.backgroundColor = UIColor.secondaryBackgroundColor
        UIUtility.styleLabelTitle1(lbl: lblDisplayName)
        UIUtility.styleLabelBanner(lbl: lblProfileLetter)
        UIUtility.styleLabelTitle3(lbl: lblMemberSince)
        lblProfileLetter.textColor = UIColor.secondaryBackgroundColor
    }
    
    private func createAccountOptions() -> [sectionModel] {
        var ret = [sectionModel]()
        
        //Payments & Winnings
        var menuItems = [menuItem]()
        menuItems.append(menuItem(title: "Claim Prize"))
        menuItems.append(menuItem(title: "Contest History"))
        menuItems.append(menuItem(title: "Manage Payments"))
        var section = sectionModel(sectionName: "Payments & Winnings", menuItems: menuItems)
        
        ret.append(section)
        
        //Account
        menuItems = [menuItem]()
        menuItems.append(menuItem(title: "Terms & Conditions"))
        menuItems.append(menuItem(title: "Contest Rules"))
        menuItems.append(menuItem(title: "Logout"))
        section = sectionModel(sectionName: "Account", menuItems: menuItems)
        
        ret.append(section)
        
        return ret
    }
}

// Mark: - UITableView
extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let headerLbl = UILabel(frame: CGRect(x: 20, y: 12, width:
            tableView.bounds.size.width, height: tableView.bounds.size.height))
        
        UIUtility.styleTableViewSectionTitle(lbl: headerLbl)
        headerLbl.text = accountSections[section].sectionName
        headerLbl.sizeToFit()
        headerView.addSubview(headerLbl)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? AccountTableViewCell else {
            return
        }
         
        selectedCell.select()
        
        if indexPath.section == 0 {
            if indexPath.row == 0 || indexPath.row == 1 {
                performSegue(withIdentifier: seguePurchaseHistoryIdentifier, sender: self)
            }
            
            if indexPath.row == 2 {
                paymentContext.presentPaymentMethodsViewController()
            }
        }
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                UIApplication.shared.open(URL(string: urls.terms)!, options: [:]) { (success) in
                    selectedCell.deSelect()
                }
            }
            
            if indexPath.row == 1 {
                UIApplication.shared.open(URL(string: urls.contestRules)!, options: [:]) { (success) in
                    selectedCell.deSelect()
                }
            }
            
            if indexPath.row == 2 {
               performSegue(withIdentifier: segueLogoutIdentifier, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        if let selectedCell = selectedCell as? AccountTableViewCell {
            selectedCell.deSelect()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let accountSections = accountSections else {
            return 0
        }
        return accountSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let accountSections = accountSections else {
            return 0
        }
        return accountSections[section].menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier, for: indexPath)

        guard let accountCell = cell as? AccountTableViewCell else {
            return cell
        }
        
        accountCell.lblTitle.text = accountSections[indexPath.section].menuItems[indexPath.row].title
        
        return accountCell
    }
}

// MARK: - STPPaymentContextDelegate
extension AccountViewController: STPPaymentContextDelegate {
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        print("paymentContextDidChange")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        print("didFailToLoadWithError")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        print("didCreatePaymentResult")
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        print("didFinishWith status")
    }
}

// MARK: - sectionModel
private struct sectionModel {
    var sectionName: String
    var menuItems: [menuItem]
}

private struct menuItem {
    var title: String
}
