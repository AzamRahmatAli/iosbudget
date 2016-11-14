//
//  CustomCollectionViewCell.swift
//  budget
//
//  Created by Azam Rahmat on 8/19/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var img: UIImageView!
    override var selected: Bool {
        
        didSet {
            //self.alpha = self.selected ? 1.0 : 0.5
            
            self.layer.borderWidth = self.selected ? 2.0 : 0.0
            self.layer.borderColor = UIColor.grayColor().CGColor
            
        }
    }
}
