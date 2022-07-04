//
//  CourseView.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/7/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit

class CourseView: UIView {
    let kCONTENT_XIB_NAME = "CourseView"

    @IBOutlet weak var imgCourse: UIImageView!
    @IBOutlet var viewContent: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func setValues(courseModel: CourseModel) {
        imgCourse.imgLoad(imageUrl: courseModel.imageUrl!)
        imgLogo.imgCourseLogoLoad(imageUrl: courseModel.logoUrl!)
    }
    
    // Private Helpers
    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        viewContent.fixInView(self)
    }

}
