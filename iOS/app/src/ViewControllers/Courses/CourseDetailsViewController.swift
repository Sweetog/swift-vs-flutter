//
//  CourseDetailsViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/4/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class CourseDetailsViewController: BaseViewController {
    
    @IBOutlet weak var viewCourse: CourseView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTitleContainer: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableViewContests: UITableView!
    
    var courseId:String!
    private let contestCellIdentifier = "courseDetailsContestCell"
    private let contestRowHeight = UIUtility.defaultLargeRowHeight
    private var contests:[ContestModel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
        
        if courseId == nil {
            fatalError()
        }
        
        tableViewContests.delegate = self
        tableViewContests.dataSource = self
        
        //adding an invisible footer so that UIKit will NOT fill empty space below the rows in the table with empty row
        tableViewContests.tableFooterView = UIView(frame: .zero)
        
        let nib = UINib.init(nibName: "ContestTableViewCell", bundle: nil)
        tableViewContests.register(nib, forCellReuseIdentifier: contestCellIdentifier)
        
        styleUIComponents()
    }
    
    override func viewWillAppear(_ animated: Bool){
        loadContests()
    }
    
    @IBAction func btnCancelTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Helpers
    private func loadContests() {
        activityIndicator.startAnimating()
        ContestRepository.getToday { (contests, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                UIUtility.popConfirmationAlertOkDismiss(self, title: "Error Loading Contests", message: "\(error.localizedDescription)", dismiss: {})
                return
            }
            self.contests = contests
            
            if contests == nil { return }
            if contests!.count <= 0 { return }
            
            self.setDisplay(courseModel: self.contests[0].courseModel!)
            self.tableViewContests.reloadData()
        }
    }
    
    private func styleUIComponents() {
        UIUtility.styleLabelTitle2(lbl: lblTitle)
        UIUtility.styleContainerViewTitleFullWidth(view: viewTitleContainer)

        self.tableViewContests.backgroundColor = UIColor.secondaryBackgroundColor
        self.tableViewContests.separatorColor = UIColor.clear
    }
    
    private func setDisplay(courseModel: CourseModel) {
        viewCourse.setValues(courseModel: courseModel)
        lblTitle.text = "Hole - \(courseModel.hole)    Par - \(courseModel.par)    HDCP - \(courseModel.handicap)"
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CourseDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell = tableView.dequeueReusableCell(withIdentifier: contestCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        guard let contestCell = cell as? ContestTableViewCell else {
            return cell
        }
        
        let contest = contests[indexPath.section]
        
        contestCell.setValuesCourseDetailsView(contest: contest)
        
        return contestCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        tableView.deselectRow(at: indexPath, animated: false)
        
        let contest = contests[indexPath.section]
        
        if contest.contests != nil && contest.contests!.count > 0 {
            UIUtility.presentComboContest(currentVc: self, contestModel: contest)
            return
        }
        
        UIUtility.presentContest(currentVc: self, contestModel: contest)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contestRowHeight
    }
    
}


