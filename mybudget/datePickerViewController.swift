//
//  datePickerViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/16/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit

class datePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var currentDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        
        let selectedDate = dateFormatter.stringFromDate(NSDate())
        currentDate.text = selectedDate
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func pickDate(sender: AnyObject) {
        currentDate.text = String(datePicker.date)
        Helper.datePic = datePicker.date
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func changeDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        
        let selectedDate = dateFormatter.stringFromDate(sender.date)
        currentDate.text = selectedDate
        
        
    }
    
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
