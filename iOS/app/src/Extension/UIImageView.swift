//
//  UIImageView.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 4/3/19.
//  Copyright © 2019 Big Money Shot. All rights reserved.
//

import UIKit
import AlamofireImage

extension UIImageView {

    
    func imgLoad(imageUrl:URL){
        self.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIUtility.defaultImageTransition, runImageTransitionIfCached: true) { (resp) in
        }
    }
    
    func imgCourseLogoLoad(imageUrl:URL) {
        self.af_setImage(withURL: imageUrl, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIUtility.defaultImageTransition, runImageTransitionIfCached: true) { (resp) in
            // Check if the image isn't already cached
            if resp.response != nil {
                self.image = UIImage(data: resp.data!)!.withRenderingMode(.alwaysTemplate)
            }else{
                self.image = self.image!.withRenderingMode(.alwaysTemplate)
            }
        }
        self.tintColor = UIColor.primaryForegroundColor
    }
}
