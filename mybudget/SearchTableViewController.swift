//
//  SearchTableViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/28/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class SearchTableViewController: UITableViewController {
    let searchController = UISearchController(searchResultsController : nil)
    @IBOutlet weak var searchBar: UISearchBar!
    var expenseData : [ExpenseTable] = []
    var filteredExpenses : [ExpenseTable] = []
    
    func filterContentForSearchText(text : String)
          {
    filteredExpenses = expenseData.filter{ expense in
        let lowerCaseText = text.lowercaseString
        var accountName = ""
        if let account = expense.account?.name
        {
            accountName = account
        }
        return (
            expense.subCategory!.category!.name!.lowercaseString.containsString(lowerCaseText) ||
            expense.subCategory!.name!.lowercaseString.containsString(lowerCaseText) ||
            expense.note!.lowercaseString.containsString(lowerCaseText) ||
            expense.amount!.containsString(lowerCaseText) ||
            String(expense.createdAt).containsString(lowerCaseText) ||
            accountName.lowercaseString.containsString(lowerCaseText) 
        )
        
    }
    tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }

  

    // MARK: - Table view data source

 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return filteredExpenses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
       
        
       
        
        cell.subCatg.text = filteredExpenses[indexPath.row].subCategory!.name
        //Helper.currency + expenseDataForSection![indexPath.row].amount!
        let amount = Float(filteredExpenses[indexPath.row].amount!)
        cell.categoryAmount.text = amount?.asLocaleCurrency
        let date = String(filteredExpenses[indexPath.row].createdAt!).componentsSeparatedByString(" ").first
        
        
        let note = filteredExpenses[indexPath.row].note ?? ""
        
        cell.leftDown.text = date! + " " + note
        if let img = filteredExpenses[indexPath.row].subCategory?.icon where img != ""
        {
            cell.img.image = UIImage(named: img)
            cell.img?.tintColor = Helper.colors[indexPath.row  % 5]
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if (segue.identifier == "updateExpense") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let dvc = segue.destinationViewController as! AddExpenseViewController
            
            dvc.expenseData = filteredExpenses[indexPath.row]
            dvc.updateExpens = true
            
            
        }
        
        
    }
    
    func getExpenses() -> [ExpenseTable]
    {
        
    
        do{
            let request = NSFetchRequest(entityName: "ExpenseTable")
            
          
            let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request) as! [ExpenseTable]
            
            
                    return queryResult
            
            
        }
        catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
           //print("error : ", error)
        }
        
        
        
        return []
        
    }
    override func viewWillAppear(animated: Bool) {
        expenseData = getExpenses()
    }

    /*
  
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
extension SearchTableViewController : UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}