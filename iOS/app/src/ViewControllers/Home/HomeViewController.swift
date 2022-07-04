//
//  HomeViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/13/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import Stripe
import CoreLocation
import AudioToolbox

class HomeViewController: BaseViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var contestsTableView: UITableView!
    @IBOutlet weak var viewRecentContestsTitleContainer: UIView!
    @IBOutlet weak var lblTitleRecentContests: UILabel!
    @IBOutlet weak var viewHeaderBtnsContainer: UIView!
    @IBOutlet weak var imgScanCode: UIImageView!
    @IBOutlet weak var imgFindCourse: UIImageView!
    @IBOutlet weak var lblScanCode: UILabel!
    @IBOutlet weak var lblFindCourse: UILabel!
    @IBOutlet weak var viewHeaderBtnsDivider: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let contestCellIdentifier = "contestCell"
    private let contestRowHeight = UIUtility.defaultLargeRowHeight
    private var contests:[ContestModel]!
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        contestsTableView.delegate = self
        contestsTableView.dataSource = self
        
        //adding an invisible footer so that UIKit will NOT fill empty space below the rows in the table with empty row
        contestsTableView.tableFooterView = UIView(frame: .zero)
        
        let nib = UINib.init(nibName: "ContestTableViewCell", bundle: nil)
        contestsTableView.register(nib, forCellReuseIdentifier: contestCellIdentifier)
        
        let scanCodeGest = UITapGestureRecognizer()
        scanCodeGest.addTarget(self, action: #selector(scanIconTouch))
        imgScanCode.addGestureRecognizer(scanCodeGest)
        
        let findCourseGest = UITapGestureRecognizer()
        findCourseGest.addTarget(self, action: #selector(findCourseTouch))
        imgFindCourse.addGestureRecognizer(findCourseGest)
        
        styleUIComponents()
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
    
        locationManager.requestAlwaysAuthorization()
        loadContests()
    }
    
    @IBAction func unwindToHomeViewController(segue:UIStoryboardSegue) { }

    // MARK: - Gesture Recognizers
    @objc func scanIconTouch(){
        UIUtility.popConfirmationAlertOkDismiss(self, title: "Coming Soon", message: "Fast Check In Option Coming Soon!") {}
    }
    
    @objc func findCourseTouch(){
        UIUtility.presentCourseDetails(currentVc: self, courseId: "ILXBlsKJW8Cdqk27MTq5")
    }
    
    @objc func noDataLblTouch(){
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("success, \(success)")
            })
        }
    }
    
    // MARK - LocationManager
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        loadContests()
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                     loadContests()
//                }
//            }
//        }
    }
    
    // MARK: - Private Helpers
    private func isLocationAuthorized() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            }
        } else {
            return false
        }
    }
    
    private func loadContests() {
        activityIndicator.startAnimating()
        ContestRepository.getToday { (contests, error) in
            self.activityIndicator.stopAnimating()
            if let error = error {
                UIUtility.popConfirmationAlertOkDismiss(self, title: "Error Loading Contests", message: "\(error.localizedDescription)", dismiss: {})
                return
            }
            self.contests = contests
            self.contestsTableView.reloadData()
        }
    }
    
    private func styleUIComponents() {
        UIUtility.styleLabelTitle2(lbl: lblTitleRecentContests)
        UIUtility.styleLabelCaption(lbl: lblScanCode)
        UIUtility.styleLabelCaption(lbl: lblFindCourse)
        
        lblScanCode.textColor = UIColor.secondaryForegroundColor
        lblFindCourse.textColor = UIColor.secondaryForegroundColor
        //lblTitleRecentContests.textColor = UIColor.secondaryForegroundColor
        
        viewHeaderBtnsDivider.backgroundColor = UIColor.primaryForegroundColor
 
        viewRecentContestsTitleContainer.backgroundColor = UIColor.secondaryBackgroundColor
        viewRecentContestsTitleContainer.roundTopCorners()

        viewHeaderBtnsContainer.backgroundColor = UIColor.secondaryBackgroundColor
        viewHeaderBtnsContainer.roundTopCorners()
        
        contestsTableView.backgroundColor = UIColor.secondaryBackgroundColor
        contestsTableView.separatorColor = UIColor.clear
        
        imgScanCode.image = UIImage(named: imageNames.iconQrcode)!.withRenderingMode(.alwaysTemplate)
        imgScanCode.tintColor = UIColor.primaryForegroundColor
        imgFindCourse.image = UIImage(named: imageNames.iconPin)!.withRenderingMode(.alwaysTemplate)
        imgFindCourse.tintColor = UIColor.primaryForegroundColor
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let frame = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        if !isLocationAuthorized() {
            let noDataLabel: UILabel = UILabel(frame: frame)
            noDataLabel.text = "Touch Here to Enable Location"
            UIUtility.styleLabelNoData(lbl: noDataLabel)
            tableView.backgroundView = noDataLabel
            let noDataLblGest = UITapGestureRecognizer()
            noDataLblGest.addTarget(self, action: #selector(noDataLblTouch))
            noDataLabel.addGestureRecognizer(noDataLblGest)
            return 0
        } else {
            let view = UIView(frame: frame)
            view.backgroundColor = UIColor.secondaryBackgroundColor
            tableView.backgroundView = view
        }
        
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
        
        contestCell.setValues(contest: contest)
        
        return contestCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        tableView.deselectRow(at: indexPath, animated: false)
        
        let contest = contests[indexPath.section]
        
        if contest.contests != nil && contest.contests!.count > 0 {
            //all in one contest
            UIUtility.presentComboContest(currentVc: self, contestModel: contest)
            return
        }
        
        UIUtility.presentContest(currentVc: self, contestModel: contest)
        //preset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return contestRowHeight
    }
    
}
