//
//  SetBudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/8/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class SetBudgetViewController: UIViewController , UITextFieldDelegate{

   

    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var category: UILabel!

    @IBOutlet weak var subCategory: UILabel!
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    var crntCategory = ""
    
    var crntSubCategory = ""
    var crntAmount = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        category.text = crntCategory
        subCategory.text = crntSubCategory
        amount.text = crntAmount
        amount.delegate = self
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SetBudgetViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
       
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Constants.Picker.chooseSubCategory = true
        if textField  == amount
        {
            if amount.text == "0"
            {
            amount.text = ""
            }
            return true
        }
        return false
    }
    
    
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let aSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
        let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
        let numberFiltered = compSepByCharInSet.joinWithSeparator("")
        let countdots = textField.text!.componentsSeparatedByString(".").count - 1
        
        if countdots > 0 && string == "."
        {
            return false
        }
        return string == numberFiltered
        
    }
    @IBAction func Cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addExpense(sender: AnyObject) {
        
        /*if let expense = NSEntityDescription.insertNewObjectForEntityForName("BudgetTable", inManagedObjectContext: managedObjectContext!) as? BudgetTable
        {
            expense.category = category.text
            expense.expenses = Int(amount.text!)
            expense.subCategory = subCategory.text
            expense.createdAt = NSDate()
            
            expense.icon = "home"
            
            
           //print(expense)
            
            
        }
        else{
           //print("fail insert")
        }
        
        
        
        do{
            try self.managedObjectContext?.save()
            navigationController?.popViewControllerAnimated(true)
            //receivedMessageFromServer()
            
        }
        catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
            
        }*/
        
        
        let predicate = NSPredicate(format: "category.name == %@ AND name == %@", crntCategory, crntSubCategory)
        
        let fetchRequest = NSFetchRequest(entityName: "SubCategoryTable")
        fetchRequest.predicate = predicate
        
        do {
            let entity = try self.managedObjectContext!.executeFetchRequest(fetchRequest) as! [SubCategoryTable]
            
            
                //entity.first?.category = crntCategory
                
                //entity.first?.subCategory = crntSubCategory
            entity.first?.amount = amount.text
                // ... Update additional properties with new values
            
        } catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
            // Do something in response to error condition
        }
        
        do {
            try self.managedObjectContext!.save()
            navigationController?.popViewControllerAnimated(true)
        } catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
            // Do something in response to error condition
        }
    }

}
