//
//  SCBudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/8/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.

import UIKit
import CoreData

class SCBudgetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedIndexPath : NSIndexPath?
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    var subCategories = [SubCategoryTable]()
    var category : CategoryTable?
    var available : Float = 0
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var edit: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var totalAmountAvailable: UILabel!
    @IBOutlet weak var budgetTotalLabel: UILabel!
    
    override func viewDidLoad() {
        self.titleLabel.text = category!.name
        if Helper.pickCategory
        {
            editView.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        available = 0
        UpdateView()
    }
    
    func UpdateView()
    {
        
        
        subCategories = []
        
        
        do{
            
            let predicate = NSPredicate(format: "category.name == %@", category!.name!)
            let request = NSFetchRequest(entityName: "SubCategoryTable")
            request.predicate = predicate
            
            
            let queryResult = try managedObjectContext?.executeFetchRequest(request) as! [SubCategoryTable]
            
            subCategories = queryResult
            
            var totalAmount : Float = 0
            for element in subCategories
            {
                
                totalAmount += Float(element.amount ?? "0" ) ?? 0.0
                
            }
            budgetTotalLabel.text = totalAmount.asLocaleCurrency
        }
        catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
           //print("error : ", error)
        }
        
        tableView.reloadData()
        
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       //print(subCategories.count)
        return subCategories.count
        
    }
    
    
    func getExpensesForCategory(row : Int) -> Float?
    {
        // if expenseData[row].expense != nil{
        var amount : Float = 0.0
        let expenseArray = subCategories[row].expense?.allObjects as? [ExpenseTable]
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
        }
        
        
        if amount != 0
        {
            return amount
        }
        //}
        return nil
    }
    
    func getBudgetForCategory(row : Int) -> Float?
    {
        
        var amount : Float = 0.0
        
        if let price = Float(subCategories[row].amount ?? "0")
        {
            amount += price
        }
        
        
        if amount != 0
        {
            return amount
        }
        return nil
    }
    
    /*func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 48.0
    }*/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cellparent", forIndexPath: indexPath) as! ParentTableViewCell
        
        
        cell.leftUp.text = subCategories[indexPath.row].name
        cell.img.tintColor = Helper.colors[indexPath.row % 5]
        cell.img.tintColor = UIColor.whiteColor()
        cell.viewInCell.backgroundColor = Helper.colors[indexPath.row % 5]
        cell.rightUp.text = ""
        cell.leftDown.text = ""
        cell.rightDown.text = ""
        
        
        if let budget = getBudgetForCategory(indexPath.row)
        {
            cell.rightUp.text = budget.asLocaleCurrency
            if let expenses = getExpensesForCategory(indexPath.row)
            {
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
        
        
        if let scicon = subCategories[indexPath.row].icon
        {
            cell.img.image = UIImage(named: scicon)
        }
        return cell
        
    }
    
    
    /* override func willMoveToParentViewController(parent: UIViewController?) {
     if parent == nil {
     if Helper.pickCategory        {
     Helper.pickCategory  = false
     }
     }
     }*/
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.indexPathForSelectedRow!
        
        if Helper.pickCategory
        {
            
            Helper.pickedSubCaregory = subCategories[indexPath.row]
            
            Helper.pickCategory = false
            Helper.categoryPicked = true
            navigationController?.popViewControllerAnimated(true)
        }
        else if (self.tableView.editing) {
            
            performSegueWithIdentifier("updateSubcategory", sender: nil)
        }
        else {
            
            
            self.performSegueWithIdentifier("setBudget", sender: nil)
            
        }
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "addSubCategory") {
            let dvc = segue.destinationViewController as! AddBudgetCGViewController
            
            dvc.addSubCategory = true
            dvc.category = category
            
        }
        else if (segue.identifier == "updateSubcategory") {
            let dvc = segue.destinationViewController as! AddBudgetCGViewController
            let path = self.tableView.indexPathForSelectedRow!
            dvc.addSubCategory = true
            dvc.update = true
            dvc.category = category
            dvc.subcategory = subCategories[path.row]
            
        }
            
            
        else if (segue.identifier == "setBudget")
        {
            let path = self.tableView.indexPathForSelectedRow!
            let dvc = segue.destinationViewController as! SetBudgetViewController
            
            dvc.crntCategory = subCategories[path.row].category!.name!
            dvc.crntSubCategory = subCategories[path.row].name!
            if let amount = subCategories[path.row].amount
            {
                dvc.crntAmount = amount
            }
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
            
            if let category = SubCategoryTable.subCategory(subCategories[indexPath.row].name!,categoryName: category!.name!, inManagedObjectContext: managedObjectContext!)
            {
                if category.expense?.count < 1{
                    
                    managedObjectContext!.deleteObject(category)
                    do {
                        try managedObjectContext!.save()
                        
                        
                    } catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
                       //print("error")
                    }
                    subCategories.removeAtIndex(indexPath.row)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                }
                else
                {
                    let alertController = UIAlertController(title: "Delete not allowed", message: "Expense entries exist. Delete them first", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    
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