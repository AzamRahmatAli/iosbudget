//
//  AddAccountViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class AddAccountViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var asOfAccount: UILabel!
    @IBOutlet weak var currentAmount: UILabel!
    @IBOutlet weak var fundsout: UILabel!
    @IBOutlet weak var reconciledAmount: UILabel!
    @IBOutlet weak var fundsIn: UILabel!
    
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var subCategory: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var summary: UIView!
    @IBOutlet weak var missing: UILabel!
    //@IBOutlet weak var dateValue: UITextField!
    var updateAccount = false
    var accountData : AccountTable?
    
    
    var accountDate : NSDate? = NSDate()
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    @IBAction func info(sender: UIButton) {
        let alertController = UIAlertController(title: "Account Type", message: "Enter one of Checking, Savings, Credit, Debit, Cash, etc", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    @IBAction func deleteAccount(sender: UITapGestureRecognizer) {
        let accountTypeName = accountData?.accountType?.name
        
        deleteRecord(accountData!)
        deleteAccountType(accountTypeName!)
        Helper.saveChanges(managedObjectContext!, viewController: self)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //dateValue.delegate = self
        amount.delegate = self
        category.delegate = self
        subCategory.delegate = self
        
        icon.image = UIImage(named: "bank")
        icon.tintColor = Helper.colors[0]
        //subCategory.delegate = self
        
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddAccountViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        if updateAccount
        {
            
            
            
            var remaining : Float = Float(accountData!.amount!)!
            var fundIn : Float = 0.0
            var fundOut : Float = 0.0
            if let incomes =  accountData!.income?.allObjects as? [IncomeTable]
            {
                for element in incomes
                {
                    remaining += Float(element.amount ?? "0") ?? 0.0
                    fundIn += Float(element.amount ?? "0") ?? 0.0
                }
            }
            if let expenses =  accountData!.expense?.allObjects as? [ExpenseTable]
            {
                for element in expenses
                {
                    remaining -= Float(element.amount ?? "0") ?? 0.0
                    fundOut += Float(element.amount ?? "0") ?? 0.0
                }
            }
            if let transfers =  accountData!.transferTo?.allObjects as? [TransferTable]
            {
                for element in transfers
                {
                    if element.transferAt?.compare(NSDate()) == .OrderedAscending
                    {
                        remaining -= Float(element.amount ?? "0") ?? 0.0
                        fundOut += Float(element.amount ?? "0") ?? 0.0
                    }
                }
            }
            if let transfers =  accountData!.transferFrom?.allObjects as? [TransferTable]
            {
                for element in transfers
                {
                    if element.transferAt?.compare(NSDate()) == .OrderedAscending
                    {
                        remaining += Float(element.amount ?? "0") ?? 0.0
                        fundIn += Float(element.amount ?? "0") ?? 0.0
                    }
                }
            }
            
            
            
            
            
            category.text = accountData!.accountType?.name
            amount.text = accountData!.amount
            
            
            accountDate = accountData!.createdAt!
            
            subCategory.text = accountData!.name
            Helper.bankIcon =  accountData!.icon!
            
            self.title = "Update Account"
            if let total = Float(accountData!.amount!)
            {
                asOfAccount.text = "As of " + String(accountData!.createdAt!).componentsSeparatedByString(" ").first!
            reconciledAmount.text = total.asLocaleCurrency
            currentAmount.text = remaining.asLocaleCurrency
            fundsIn.text = fundIn.asLocaleCurrency
            fundsout.text = fundOut.asLocaleCurrency
            }
        }
        else
        {
            
            deleteIcon.hidden = true
            summary.hidden = true
            
        }
        
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Constants.Picker.chooseSubCategory = true
        /*if textField == dateValue
        {
            self.performSegueWithIdentifier("pickDate", sender: nil)
        }else*/ if textField  == amount
        {
            if amount.text == "0"
            {
                amount.text = ""
            }
            return true
            
        }
        else if  textField  == category ||  textField  == subCategory
        {
            return true
        }
        else  {
            Helper.pickCategory = true
            self.performSegueWithIdentifier("pickCategory", sender: nil)
        }
        return false
    }
    
    
    
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField  == amount
        {
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
        else{
            return true
        }
    }


    @IBAction func Cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    func getById(id: NSManagedObjectID) -> AnyObject {
        return managedObjectContext!.objectWithID(id)
    }
    
    
    
    
    func deleteRecord(object: NSManagedObject){
        
        managedObjectContext!.deleteObject(object)
        
        
    }
    
    @IBAction func pickIcon(sender: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("pickIcon", sender: nil)
    }
    
    
    
    func deleteAccountType(accountTypeName : String)
    {
        let request = NSFetchRequest(entityName: "AccountTable")
        
        
        request.predicate = NSPredicate(format: "accountType.name == %@", accountTypeName)
        if managedObjectContext!.countForFetchRequest( request , error: nil) < 1
        {
            if let accountType = AccountTypeTable.accontType(accountTypeName, inManagedObjectContext: managedObjectContext!)
            {
                deleteRecord(accountType)
            }
        }
        
    }
    
    @IBAction func addExpense(sender: AnyObject) {
        dismissKeyboard()
        
        
        if category.text != ""
        {
            if subCategory.text != ""
            {
                if updateAccount
                {
                    
                    if let entity =  managedObjectContext!.objectWithID(accountData!.objectID)  as? AccountTable
                    {
                        
                        entity.amount = (amount.text != "") ? amount.text : "0"
                        
                        entity.icon = Helper.bankIcon
                        Helper.bankIcon = "bank"
                        
                        entity.createdAt = accountDate
                        
                        entity.name = subCategory.text
                        
                        let  accountTypeName = entity.accountType!.name
                        
                        
                        if let accountType = AccountTypeTable.accontType(category.text!, inManagedObjectContext: managedObjectContext!)
                        {
                            entity.accountType = accountType
                        }
                        
                        deleteAccountType(accountTypeName!) //if nesessary
                        
                    }
                    
                    Helper.saveChanges(managedObjectContext!, viewController : self )
                    
                }
                    
                else   if let _ = AccountTable.account(category.text!, type: category.text!, inManagedObjectContext: managedObjectContext!)
                {
                    self.navigationController?.popViewControllerAnimated(true)
                }
                else if let entity = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: managedObjectContext!) as? AccountTable
                {
                    
                    
                    
                    entity.amount = (amount.text != "") ? amount.text : "0"
                    entity.icon = Helper.bankIcon
                    Helper.bankIcon = "bank"
                    entity.name = subCategory.text
                    entity.createdAt = accountDate
                    entity.accountType = AccountTypeTable.accontType(category.text!, inManagedObjectContext: managedObjectContext!)
                    
                    print(entity)
                    
                    
                    
                    
                    
                    Helper.saveChanges(managedObjectContext!, viewController : self )
                }
            }
            else{
                missing.text = "Enter Name"
            }
        }
        else{
            missing.text = "Enter Type"
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        if let date  = Helper.datePic
        {
            accountDate = date
            Helper.datePic = nil
            
            
        }
        
        
        //dateValue.text =  Helper.getFormattedDate(accountDate!)
        icon.image = UIImage(named: Helper.bankIcon)
        
    }
    
    func receivedMessageFromServer() {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedData", object: nil)
    }
    
}
