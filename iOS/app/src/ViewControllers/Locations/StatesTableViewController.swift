//
//  StatesTableViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 3/25/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class StatesTableViewController: UITableViewController {

    let segueCoursesIdentifier = "segueCourses"
    let segueCourseDetailsIdentifier = "segueCourseDetails"
    let stateCellIdentifier = "statesCell"
    var states:[State]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBar()
     
        styleUIComponents()
        states = createStateData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CourseDetailsViewController {
            vc.courseId = "ILXBlsKJW8Cdqk27MTq5"
        }
    }
    
    // MARK: - Private Helpers
    private func styleUIComponents() {
        self.tableView.backgroundView = UIUtility.getTableBackgroundImageView()
        self.tableView.backgroundColor = UIColor.secondaryBackgroundColor
        self.tableView.separatorColor = UIColor.clear
    }
    
    private func createStateData() -> [State] {
        var states = [State]()
        
        //California
        states.append(State(imageName: "cali", name: "California"))
        states.append(State(imageName: "arizona", name: "Arizona"))
        states.append(State(imageName: "colorado", name: "Colorado"))
        states.append(State(imageName: "florida", name: "Florida"))
        states.append(State(imageName: "nevada", name: "Nevada"))
        
        return states
    }
}

// Mark: - UITableViewDataSource - UITableViewDelegate
extension StatesTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return UIUtility.defaultLargeRowHeight
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 10))
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return states.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            performSegue(withIdentifier: segueCourseDetailsIdentifier, sender: self)
            return
        }
        
        UIUtility.popConfirmationAlertOkDismiss(self, title: "Coming Soon", message: "We are growing fast, please check back soon for more courses near you!") {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIUtility.defaultHeightForHeaderSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: stateCellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        
        guard let stateCell = cell as? StatesTableViewCell else {
            return cell
        }
        
        let state = states[indexPath.section]
        stateCell.lblName.text = state.name
        stateCell.imgState.image = UIImage(named: state.imageName)
    
        return stateCell
    }
}

struct State {
    var imageName: String
    var name: String
}
