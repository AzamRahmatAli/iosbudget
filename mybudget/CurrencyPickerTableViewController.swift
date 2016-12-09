//
//  CurrencyPickerTableViewController.swift
//  budget
//
//  Created by Azam Rahmat on 9/6/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class CurrencyPickerTableViewController: UITableViewController {
    
    var currency : CurrencyDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectButton.enabled = false
        currency = CurrencyDataSource ()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    var indexPathRow = 0
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    @IBAction func Select(sender: AnyObject) {
        
        let pickedCurrencyCode : String? = currency!.currencies[indexPathRow].code
        /*let localeIdentifier = NSLocale.localeIdentifierFromComponents([NSLocaleCurrencyCode : pickedCurrencyCode!])
         print(localeIdentifier)
         
         let locale = NSLocale(localeIdentifier: localeIdentifier)
         print(locale)
         let Identifier = locale.objectForKey(NSLocaleCurrencySymbol) as? String*/
        
        
        Helper.formatter.currencyCode = pickedCurrencyCode
        Helper.formatter.currencySymbol =  Helper.getLocalCurrencySymbl(pickedCurrencyCode!)
        Currency.saveCurrencyCodeAndSymbol()
        
        navigationController?.popViewControllerAnimated(true)
        
        
    }
    // MARK: - Table view data source
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }*/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currency!.currencies.count
    }
    
    let locale = NSLocale.currentLocale()
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // cell.textLabel?.text = String(NSLocale(localeIdentifier: NSLocale.availableLocaleIdentifiers()[indexPath.row]))
        
        //let code = NSLocale.ISOCurrencyCodes()[indexPath.row]
        // cell.textLabel?.text = "\(code) : \(locale.displayNameForKey(NSLocaleCurrencyCode, value: code)!)"
        let code = currency!.currencies[indexPath.row]
        cell.textLabel?.text = " \(code.displayName) (\(code.code)) "
        
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        /*  if (segue.identifier == "updateExpense") {
         let indexPath = self.tableView.indexPathForSelectedRow!
         
         let dvc = segue.destinationViewController as! AddExpenseViewController
         
         dvc.expenseData = expenseDataForSection![indexPath.row]
         dvc.updateExpens = true
         
         
         }
         */
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectButton.enabled = true
        indexPathRow = indexPath.row
        
    }
    
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
