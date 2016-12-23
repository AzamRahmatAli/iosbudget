//
//  CurrencyPickerTableViewController.swift
//  budget
//
//  Created by Azam Rahmat on 9/6/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase
class CurrencyPickerTableViewController: UITableViewController, UISearchResultsUpdating {
    let searchController = UISearchController(searchResultsController: nil)
    
    var currencies : [Currency] = CurrencyDataSource().currencies
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //currency = CurrencyDataSource().currencies
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            searchController.searchResultsUpdater = self
            //searchController.hidesNavigationBarDuringPresentation = false
            searchController.dimsBackgroundDuringPresentation = false
            searchController.searchBar.sizeToFit()
            self.tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        
        }
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let lowerCaseText = searchController.searchBar.text!.lowercaseString
        if lowerCaseText != ""
        {
            currencies = currencies.filter{ currency in
            
        
            
            
            return (
                currency.displayName.lowercaseString.containsString(lowerCaseText) ||
                currency.code.lowercaseString.containsString(lowerCaseText)
                
            )
            
        }
        }
        else{
            currencies = CurrencyDataSource().currencies
        }
        tableView.reloadData()
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    // MARK: - Table view data source
    
    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }*/
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currencies.count
    }
    
    let locale = NSLocale.currentLocale()
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // cell.textLabel?.text = String(NSLocale(localeIdentifier: NSLocale.availableLocaleIdentifiers()[indexPath.row]))
        
        //let code = NSLocale.ISOCurrencyCodes()[indexPath.row]
        // cell.textLabel?.text = "\(code) : \(locale.displayNameForKey(NSLocaleCurrencyCode, value: code)!)"
        let code = currencies[indexPath.row]
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
        let pickedCurrencyCode : String? = currencies[indexPath.row].code
        /*let localeIdentifier = NSLocale.localeIdentifierFromComponents([NSLocaleCurrencyCode : pickedCurrencyCode!])
         //print(localeIdentifier)
         
         let locale = NSLocale(localeIdentifier: localeIdentifier)
         //print(locale)
         let Identifier = locale.objectForKey(NSLocaleCurrencySymbol) as? String*/
        
        
        Helper.formatter.currencyCode = pickedCurrencyCode
        Helper.formatter.currencySymbol =  Helper.getLocalCurrencySymbl(pickedCurrencyCode!)
        
        FIRAnalytics.setUserPropertyString("yes", forName: "set_currency")
        
        Helper.FIRAnalyticsLogEvent("set_currency", value: "set_currency " + Helper.formatter.currencyCode + " " + Helper.formatter.currencySymbol )
        
        
        Currency.saveCurrencyCodeAndSymbol()
        searchController.searchBar.hidden = true
        view.endEditing(true)
        navigationController?.popViewControllerAnimated(true)
        
        
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
