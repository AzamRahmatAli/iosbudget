//
//  TransferViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/21/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class TransferViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var date: UITextField!

    @IBOutlet weak var doThisBefore: UILabel!
    @IBOutlet weak var amount: UITextField!
    @IBOutlet weak var toAccount: UITextField!
    @IBOutlet weak var fromAccount: UITextField!
    
    var AccountFrom : AccountTable?
    var Accountto : AccountTable?
    
    var transferDate : NSDate = NSDate()
    var from  = false
    var to  = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amount.delegate = self
        date.delegate = self
        toAccount.delegate = self
        fromAccount.delegate = self
        // Do any additional setup after loading the view.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddIncomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
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
        if textField == date
        {
            self.performSegueWithIdentifier("pickDate", sender: nil)
        }else if textField  == amount
        {
            if amount.text == "0"
            {
                amount.text = ""
                
            }
            return true
        }
        else if textField  ==    fromAccount

        {
            from = true
             Helper.pickAccount = true
            self.performSegueWithIdentifier("pickAccount", sender: nil)
            
        }
            
        else if textField  ==    toAccount{
            to = true
            Helper.pickAccount = true
            self.performSegueWithIdentifier("pickAccount", sender: nil)
           
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
    @IBAction func transfer(sender: AnyObject) {
        
        view.endEditing(true) //hide keyboard to show msg
        if Float(amount.text ?? "0") ?? 0 > 0
        {
        if AccountFrom != nil && Accountto != nil{
             if AccountFrom != Accountto
             {
        if let entity = NSEntityDescription.insertNewObjectForEntityForName("TransferTable", inManagedObjectContext: Helper.managedObjectContext!) as? TransferTable
        {
            
            
            entity.transferAt = transferDate
            entity.amount = (amount.text != "") ? amount.text : "0"
            //entity.account = account.text
          
            
            if let account = AccountFrom
            {
            entity.fromAccount = account
            }
            if let account = Accountto
            {
            entity.toAccount = account
            }
            
            //print(expense)
            do{
                try Helper.managedObjectContext?.save()
                
                
                FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                    kFIRParameterItemID : "transfer_account" as NSObject,
                    kFIRParameterContentType : "transfered_account" as NSObject
                    ])
                    /*
                    kFIRParameterValue : amount.text! as NSObject,
                    kFIRParameterItemCategory: "from " + AccountFrom!.name! + " to " + Accountto!.name! as NSObject,
                    ])*/
                navigationController?.popViewControllerAnimated(true)
                //receivedMessageFromServer()
                
            }
            catch{
                
            }
            
        }
            }
             else{
                doThisBefore.text = "From and To accounts are same"
            }
        }
        else{
            doThisBefore.text = "Select account"
        }
        }else{
            doThisBefore.text = "Amount cannot be 0"
        }
       
        
        }
    override func viewWillAppear(animated: Bool) {
        
       
        
        if from
        {
            
            
            Helper.pickAccount = false
            Helper.accountPicked = false
            if let account = Helper.pickedAccountData
            {
                fromAccount.text = account.name
                AccountFrom = account
                Helper.pickedAccountData = nil
            }
            from = false
        }
        else if to
        {
            Helper.pickAccount = false
            Helper.accountPicked = false
            if let account = Helper.pickedAccountData
            {
                toAccount.text = account.name
                Accountto = account
                Helper.pickedAccountData = nil
            }
           to = false
            
        }
            
        else if let date  = Helper.datePic
        {
            transferDate = date
            Helper.datePic = nil
            
            
        }
 
        date.text = Helper.getFormattedDate(transferDate)
        
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
