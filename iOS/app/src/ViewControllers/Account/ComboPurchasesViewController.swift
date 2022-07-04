//
//  PurchasesComboViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/7/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class ComboPurchasesViewController: BaseViewController {
    
    @IBOutlet weak var tableViewPurchases: UITableView!
    
    private let purchasesComboCellReuseIdentifer = "purchasesComboCell"
    private let segueComboPurchaseClaimIdentifier = "segueComboPurchaseClaim"
    var purchase:PurchaseModel!
    private var contests:[ContestModel]!
    private var activityIndicator:UIActivityIndicatorView!
    private var selectedContest: ContestModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        
        if purchase == nil {
            fatalError()
        }
        
        if purchase.contest.contests == nil {
            fatalError()
        }
        
        contests = purchase.contest.contests
        
        tableViewPurchases.delegate = self
        tableViewPurchases.dataSource = self
        
        let nib = UINib.init(nibName: "ContestTableViewCell", bundle: nil)
        tableViewPurchases.register(nib, forCellReuseIdentifier: purchasesComboCellReuseIdentifer)
        
        //adding an invisible footer so that UIKit will NOT fill empty space below the rows in the table with empty row
        tableViewPurchases.tableFooterView = UIView(frame: .zero)
   
        styleUIComponents()
        addActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool){

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedContest = selectedContest else {
            return
        }
        
        if let vc = segue.destination as? ClaimViewController {
            vc.purchaseId = purchase.id!
            vc.comboContest = selectedContest
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
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ComboPurchasesViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let contests = contests else {
            return 0
        }
        
        return contests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: purchasesComboCellReuseIdentifer, for: indexPath)
        cell.selectionStyle = .none
        
        guard let purchaseCell = cell as? ContestTableViewCell else {
            return cell
        }
        
        let contest = contests[indexPath.section]
        
        purchaseCell.setValuesComboPurchase(purchase: purchase, contest: contest)
        
        return purchaseCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        tableView.deselectRow(at: indexPath, animated: false)
        
        selectedContest = contests[indexPath.section]
        
        performSegue(withIdentifier: segueComboPurchaseClaimIdentifier, sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIUtility.defaultLargeRowHeight
    }
    
}

