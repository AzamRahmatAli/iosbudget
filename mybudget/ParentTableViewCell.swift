//
//  ParentTableViewCell.swift
//  budget
//
//  Created by Azam Rahmat on 7/27/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class ParentTableViewCell: UITableViewCell{
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBOutlet weak var subCatg: UILabel!
    
    @IBOutlet weak var leftUp: UILabel!
    
    @IBOutlet weak var leftDown: UILabel!
    
    @IBOutlet weak var categoryAmount: UILabel!
    
    @IBOutlet weak var rightDown: UILabel!
    @IBOutlet weak var rightUp: UILabel!

    @IBOutlet weak var img: UIImageView!
    
    
    @IBOutlet weak var viewInCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
