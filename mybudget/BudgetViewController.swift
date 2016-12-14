//
//  BudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/8/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData


class BudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    var expenseData : [CategoryTable]?
    
    @IBOutlet weak var editAndOneBudget: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var budgetTotalLabel: UILabel!
    @IBOutlet weak var edit: UIButton!
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return expenseData!.count
        
    }
    
    
    override func viewDidLoad() {
        if Helper.pickCategory
        {
            editAndOneBudget.hidden = true
        }
    }
    override func viewWillAppear(animated: Bool) {
        if Helper.categoryPicked
        {
            
            navigationController?.popViewControllerAnimated(true)
        }
        else
        {
            UpdateView()
        }
        
    }
    
    func UpdateView()
    {
        
        
        expenseData = []
        
        
        do{
            let request = NSFetchRequest(entityName: "CategoryTable")
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [CategoryTable]
            
            
            
            
            
            expenseData = queryResult
            var totalAmount : Float = 0
            for element in expenseData!
            {
                
                
                let subcategory = element.subcategory!.allObjects as! [SubCategoryTable]
                
                for element in subcategory{
                    if let price = Float(element.amount ?? "0")
                    {
                        totalAmount += price
                    }
                    
                }
                
            }
            
            
            if totalAmount == 0.0
            {
                do{
                    let request = NSFetchRequest(entityName: "Other")
                    
                    let queryResult = try managedObjectContext?.executeFetchRequest(request).first
                    if let result = queryResult as? Other{
                        totalAmount = Float(result.oneBudget ?? "0") ?? 0.0
                    }
                }
                catch let error {
                   //print("error : ", error)
                }
            }
            budgetTotalLabel.text = totalAmount.asLocaleCurrency
            
            
        }
        catch let error {
           //print("error : ", error)
        }
        
        tableView.reloadData()
        
        
        
    }
    
    func getBudgetForCategory(name : String, row : Int) -> Float?
    {
        let data = expenseData![row].subcategory!.allObjects as! [SubCategoryTable]
        var amount : Float = 0.0
        for element in data{
            if let price = Float(element.amount ?? "0")
            {
                amount += price
            }
            
        }
        if amount != 0
        {
            return amount
        }
        return nil
    }
    
    func getExpensesForCategory(row : Int) -> Float?
    {
        // if expenseData[row].expense != nil{
        var amount : Float = 0.0
        
        if let subCategories = expenseData![row].subcategory?.allObjects as? [SubCategoryTable]
        {
            for category in subCategories
            {
                let expenseArray = category.expense?.allObjects as? [ExpenseTable]
                let filteredExpenses : [ExpenseTable]? = expenseArray!.filter{ expense in
                    let (startDate , endDate) =  NSDate().getDatesOfRange(.Month)
                    
                    return  expense.createdAt!.compare(startDate) == .OrderedDescending && expense.createdAt!.compare(endDate) == .OrderedAscending
                    
                    
                }
                if let expenses = filteredExpenses
                
                {
                    for expense in expenses
                    {
                        amount += Float(expense.amount ?? "0") ?? 0.0
                    }
                }            }
        }
        
        
        if amount != 0
        {
            return amount
        }
        //}
        return nil
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        let index = indexPath.row
        let ctgName = expenseData![index].name
        cell.rightUp.text = ""
        cell.leftDown.text = ""
        cell.rightDown.text = ""
        cell.leftUp.text = ctgName
        
        cell.img.image = UIImage(named: expenseData![index].icon!)
        cell.img.tintColor = UIColor.whiteColor()
        cell.viewInCell.backgroundColor = Helper.colors[indexPath.row % 5]
        
        if let budget = getBudgetForCategory(ctgName!,row: indexPath.row)
        {
            cell.rightUp.text = budget.asLocaleCurrency
            
            if let expenses = getExpensesForCategory(indexPath.row)
            {
                //print(ctgName)
                cell.leftDown.text = expenses.asLocaleCurrency
                cell.rightDown.text = (budget - expenses).asLocaleCurrency
                if (budget - expenses) >= 0
                {
                    cell.rightDown.textColor = UIColor(red: 37/255, green: 162/255, blue: 77/255, alpha: 1)
                }
                else{
                    cell.rightDown.textColor = UIColor.redColor()
                }
            }
            
        }//if budget is not set
        else if let expenses = getExpensesForCategory(indexPath.row)
        {
            //print("budget is not set",ctgName)
            cell.rightUp.text = Float(0).asLocaleCurrency
            cell.leftDown.text = expenses.asLocaleCurrency
            cell.rightDown.text = (0.0 - expenses).asLocaleCurrency
            if (0.0 - expenses) >= 0
            {
                cell.rightDown.textColor = UIColor(red: 37/255, green: 162/255, blue: 77/255, alpha: 1)
            }
            else{
                cell.rightDown.textColor = UIColor.redColor()
            }
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
        if (self.tableView.editing) {
            
            performSegueWithIdentifier("updateCategory", sender: nil)
        }
        else{
            
            
            performSegueWithIdentifier("subcategory", sender: nil)
            
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addCategory") {
            let dvc = segue.destinationViewController as! AddBudgetCGViewController
            
            dvc.addCategory = true
            
        }
        else  if (segue.identifier == "updateCategory") {
            let path = self.tableView.indexPathForSelectedRow!
            let dvc = segue.destinationViewController as! AddBudgetCGViewController
            dvc.addCategory = true
            dvc.update = true
            dvc.category = expenseData![path.row]
            
        }
            
            
        else if let _ = self.tableView.indexPathForSelectedRow
        {
            let path = self.tableView.indexPathForSelectedRow!
            let dvc = segue.destinationViewController as! SCBudgetViewController
            let index = path.row
            
            dvc.category = expenseData![index]
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return self.tableView.editing
    }
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        //return true
    }
    @IBAction func showEditing(sender: UIButton)
    {
        if(self.tableView.editing == true)
        {
            self.tableView.editing = false
            
            self.edit?.setTitle("Edit", forState: UIControlState.Normal)
            
        }
        else
        {
            self.tableView.editing = true
            self.tableView.allowsSelectionDuringEditing = true;
            self.edit?.setTitle("Done", forState: UIControlState.Normal)
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //let request = NSFetchRequest(entityName: "SubCategoryTable")
            
            //let calendar = NSCalendar.currentCalendar()
            //let components = calendar.components([.Month , .Year], fromDate: NSDate())
            //let startDate = NSDate().startOfMonth(components)
            //let endDate = NSDate().endOfMonth(components)
            //request.predicate = NSPredicate(format: "expense.createdAt >= %@ AND expense.createdAt <= %@ AND category.name == %@", startDate!, endDate!  , expenseData![indexPath.row].name!)
            
            //request.predicate = NSPredicate(format: "category.name == %@", expenseData![indexPath.row].name!)
            /*if managedObjectContext!.countForFetchRequest( request , error: nil) < 1
             {
             if let category = CategoryTable.categoryByOnlyName(expenseData![indexPath.row].name!, inManagedObjectContext: managedObjectContext!)
             {
             managedObjectContext!.deleteObject(category)
             do {
             try managedObjectContext!.save()
             
             
             } catch {
            //print("error")
             }
             
             expenseData!.removeAtIndex(indexPath.row)
             tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
             }
             
             }*/
            if let category = CategoryTable.categoryByOnlyName(expenseData![indexPath.row].name!, inManagedObjectContext: managedObjectContext!)
            {
                if category.subcategory?.count < 1{
                    
                    managedObjectContext!.deleteObject(category)
                    do {
                        try managedObjectContext!.save()
                        
                        
                    } catch {
                       //print("error")
                    }
                    expenseData!.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
                else{
                    let alertController = UIAlertController(title: "Delete not allowed", message: "Delete the subcategories first", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                       //print("OK")
                    }
                    
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
                
                
            }
        }
    }
    
    
}