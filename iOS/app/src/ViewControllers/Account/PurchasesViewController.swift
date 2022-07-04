//
//  PurchasesViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/4/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class PurchasesViewController: BaseViewController {
    
    @IBOutlet weak var tableViewPurchases: UITableView!
    
    private let purchasesCellIdentifier = "purchasesCell"
    private let segueClaimIdentifier = "segueClaim"
    private let segueComboPurchaseIdentifier = "segueComboPurchase"
    private var purchases:[PurchaseModel]!
    private var activityIndicator:UIActivityIndicatorView!
    private var selectedPurchaseId: String?
    private var selectedPurchase: PurchaseModel?
    private var dataLoadComplete = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        
        tableViewPurchases.delegate = self
        tableViewPurchases.dataSource = self
        
        let nib = UINib.init(nibName: "ContestTableViewCell", bundle: nil)
        tableViewPurchases.register(nib, forCellReuseIdentifier: purchasesCellIdentifier)
        
        //adding an invisible footer so that UIKit will NOT fill empty space below the rows in the table with empty row
        tableViewPurchases.tableFooterView = UIView(frame: .zero)

        styleUIComponents()
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool){
        loadPurchases()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedPurchase != nil {
            guard let vcCombo = segue.destination as? ComboPurchasesViewController else {
                return
            }
            
            vcCombo.purchase = selectedPurchase
            return
        }
        
        guard let purchaseId = selectedPurchaseId else {
            return
        }
        
        if let vc = segue.destination as? ClaimViewController {
            vc.purchaseId = purchaseId
        }
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        tableViewPurchases.backgroundColor = UIColor.secondaryBackgroundColor
    }
    
    private func addActivityIndicator() {
        let frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator = UIActivityIndicatorView(frame: frame)
        activityIndicator.style = UIActivityIndicatorView.Style.white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
    }
    
    private func loadPurchases() {
        activityIndicator.startAnimating()
        PurchaseRepository.getByUserId(userId: CurrentUser.sharedInstance.uid!) { (purchases, error) in
            self.activityIndicator.stopAnimating()
            self.dataLoadComplete = true
            if let error = error {
                UIUtility.popConfirmationAlertOkDismiss(self, title: "Error Loading Contests", message: "\(error.localizedDescription)", dismiss: {})
                return
            }
            self.purchases = purchases
            self.tableViewPurchases.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PurchasesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIUtility.defaultHeightForHeaderSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        if purchases != nil && purchases.count > 0 {
            //clear No Data Label that might have been added from a previous visit to the view
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.secondaryBackgroundColor
            tableView.backgroundView = view
        }
        else {
            if !dataLoadComplete {
                return 0
            }
            
            let noDataLabel: UILabel = UILabel(frame: frame)
            noDataLabel.text = "No Recent Activity"
            UIUtility.styleLabelNoData(lbl: noDataLabel)
            tableView.backgroundView = noDataLabel
            return 0
        }
        
        return purchases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: purchasesCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        guard let purchaseCell = cell as? ContestTableViewCell else {
            return cell
        }
        
        let purchase = purchases[indexPath.section]
        
        purchaseCell.setValues(purchase: purchase)
        
        return purchaseCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        selectedPurchase = nil
        tableView.deselectRow(at: indexPath, animated: false)
        
        let purchase = purchases[indexPath.section]

        if purchase.contest.contests != nil && purchase.contest.contests!.count > 0 {
            selectedPurchase = purchase
            performSegue(withIdentifier: segueComboPurchaseIdentifier, sender: self)
            return
        }
        
        selectedPurchaseId = purchase.id
        
        performSegue(withIdentifier: segueClaimIdentifier, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIUtility.defaultLargeRowHeight
    }
    
}
