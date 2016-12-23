//
//  TableSectionHeader.swift
//  budget
//
//  Created by Azam Rahmat on 8/3/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class TableSectionHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var catg: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var separator: UIView!
    
    var headerCellSection = -1
    
    
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
