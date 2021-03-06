//
//  SettingTableViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/18/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class SettingTableViewController: UITableViewController {
    
    
    @IBOutlet weak var currency: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var lockOn: UILabel!
    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.addMenuButton(self)
        lockOn.text = "OFF"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if(indexPath.row == 1 && indexPath.section == 1)
        {
            let alertController = UIAlertController(title: "Fully reset \(StringFor.name["appName"]!)", message:  "This will delete all data that you have entered and leave  \(StringFor.name["appName"]!) as if it was newly installed. Would you like to continue?", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            Restore.fullReset()
           
                
            }
            let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                print("no")
            }
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if(indexPath.row == 1)
        {
         
        }
            
        
      
    }
    
   
    
     override func viewWillAppear(animated: Bool) {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    
                    if Helper.passwordProtectionOn
                    {
                    lockOn.text = "ON"
                    }
                    else{
                        lockOn.text = "OFF"
                    }
        
        
            currency.text = Helper.formatter.currencyCode
        
        }
    
    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }*/

    /*override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
