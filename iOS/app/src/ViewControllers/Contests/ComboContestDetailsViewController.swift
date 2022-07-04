//
//  ComboContestDetails.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/7/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

import UIKit

class ComboContestDetailsViewController: BaseViewController {
    
    @IBOutlet weak var viewCourse: CourseView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTitleContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnBuyAll: UIButton!
    @IBOutlet weak var tableViewContests: UITableView!
    @IBOutlet weak var btnCancel: UIButton!
    
    private let contestCellIdentifier = "comboContestCell"
    private let segueComboToContestDetailsIdentifier = "segueComboToContestDetails"
    private let contestRowHeight = UIUtility.defaultMediumRowHeight
    var contest:ContestModel!
    private var contests:[ContestModel]!
    private var course:CourseModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.view.addBackground()
        
        if contest == nil || contest.contests == nil || contest.courseModel == nil {
            fatalError()
        }
        
        contests = contest.contests!
        course = contest.courseModel!
        
        //sort contests by payout desc then alphabetical
        contests = contests.sorted { (prev, next) -> Bool in
            if prev.payout > next.payout {
                return true
            }
            return prev.name.lowercased() < next.name.lowercased()
        }
        
        
        tableViewContests.delegate = self
        tableViewContests.dataSource = self
        
        //adding an invisible footer so that UIKit will NOT fill empty space below the rows in the table with empty row
        tableViewContests.tableFooterView = UIView(frame: .zero)
        
        let nib = UINib.init(nibName: "ComboContestDetailTableViewCell", bundle: nil)
        tableViewContests.register(nib, forCellReuseIdentifier: contestCellIdentifier)
        
        styleUIComponents()
        setDisplay(courseModel: course)
    }
    
    override func viewWillAppear(_ animated: Bool){
        if !AuthUtility.isLoggedIn() {
            print("Failed to load authorized user in \(#function) in \(#file.components(separatedBy: "/").last ?? "")")
            UIUtility.goToSignInViewController(currentVc: self, animated: false)
            return
        }
        
        if !AuthUtility.accountCreated {
            AuthUtility.logout()
            UIUtility.goToSignInViewController(currentVc: self, animated: true)
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ContestDetailsViewController {
            vc.contestModel = contest
        }
    }
    
    @IBAction func btnBuyAllTouch(_ sender: UIButton) {
         performSegue(withIdentifier: segueComboToContestDetailsIdentifier, sender: self)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        UIUtility.styleLabelTitle2(lbl: lblTitle)
        UIUtility.styleContainerViewTitleFullWidth(view: viewTitleContainer)
        UIUtility.styleTextBtn(btn: btnCancel)
 
        self.tableViewContests.backgroundColor = UIColor.secondaryBackgroundColor
        self.tableViewContests.separatorColor = UIColor.clear
        
        UIUtility.styleCallToActionButton(btn: btnBuyAll, currentVc: self)
    }
    
    private func setDisplay(courseModel: CourseModel) {
        viewCourse.setValues(courseModel: courseModel)
        lblTitle.text = "Hole - \(courseModel.hole)    Par - \(courseModel.par)    HDCP - \(courseModel.handicap)"
        guard let amount = contest.amount else {
            fatalError()
        }
        btnBuyAll.setTitle("Enter All \(contests.count) for \(amount.displayCentsInDollarsNoDecimal())", for: .normal)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ComboContestDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.secondaryBackgroundColor
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIUtility.defaultHeightForHeaderSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let contests = contest.contests else {
            return 0
        }
        
        return contests.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: contestCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        guard let contestCell = cell as? ComboContestDetailTableViewCell else {
            return cell
        }
        
        let contest = contests[indexPath.section]
        
        contestCell.setValues(contest: contest, course: course)
        
        return contestCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        tableView.deselectRow(at: indexPath, animated: false)
        //preset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contestRowHeight
    }
    
}
