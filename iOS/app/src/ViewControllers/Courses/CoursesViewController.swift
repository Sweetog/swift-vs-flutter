//
//  CoursesViewController.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/7/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class CoursesViewController: BaseViewController {
    
    let segueCourseDetailsIdentifier = "segueCourseDetails"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CourseDetailsViewController {
            vc.courseId = "ILXBlsKJW8Cdqk27MTq5"
        }
    }
}
