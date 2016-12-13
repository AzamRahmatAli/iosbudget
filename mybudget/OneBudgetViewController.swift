//
//  OneBudgetViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/10/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class OneBudgetViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var oneBudget: UITextField!
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oneBudget.delegate = self
        let request = NSFetchRequest(entityName: "Other")
        if managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request).first as! Other
                
                oneBudget.text = queryResult.oneBudget
            }
            catch let error {
                print("error : ", error)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Constants.Picker.chooseSubCategory = true
        
        if oneBudget.text == "0"
        {
            oneBudget.text = ""
            
        }
        return true
        
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
    @IBAction func info(sender: UIButton) {
        let alertController = UIAlertController(title: "Total Budget Amount", message: "You can set one total budget amount instead of setting budget amounts at the Category/Subcategory level", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        
        
        let request = NSFetchRequest(entityName: "Other")
        
        
        
        if managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                
                let queryResult = try managedObjectContext?.executeFetchRequest(request).first as! Other
                
                queryResult.oneBudget = (oneBudget.text != "") ? oneBudget.text : "0"
                
            }
            catch let error {
                print("error : ", error)
            }
            
            
            
        }
            
        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: managedObjectContext!) as? Other
        {
            
            entity.oneBudget = (oneBudget.text != "") ? oneBudget.text : "0" //if else condition
            
            
        }
        do {
            try self.managedObjectContext!.save()
            
            FIRAnalytics.setUserPropertyString("yes", forName: "set_one_budget")
            navigationController?.popViewControllerAnimated(true)
        } catch {
            print("error")
        }
    }
    
}
