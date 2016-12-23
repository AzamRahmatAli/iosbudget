//
//  PasswordSetupViewController.swift
//  budget
//
//  Created by Azam Rahmat on 11/3/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class PasswordSetupViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var lockSwitch: UISwitch!
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordHint: UITextField! //using for hint
    @IBOutlet weak var error: UILabel!
    @IBAction func save(sender: UIBarButtonItem) {
        dismissKeyboard()
        if lockSwitch.on
        {
            if password.text != ""
            {
                if confirmPassword.text == password.text
                {
                    if passwordHint.text == ""
                    {
                        error.text = "Hint required"
                    }
                    else{
                        
                        
                        let request = NSFetchRequest(entityName: "Other")
                        
                        
                        
                        if Helper.managedObjectContext!.countForFetchRequest( request , error: nil) > 0
                        {
                            
                            do{
                                
                                
                                let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                                queryResult.lockOn = NSNumber(bool: lockSwitch.on)
                                queryResult.passwordHint = passwordHint.text //using for hint
                                queryResult.password =  password.text
                                
                            }
                            catch let nsError as NSError{
                                Helper.fireBaseSetUserProperty(nsError)
                                //print("error : ", error)
                            }
                            
                            
                            
                        }
                            
                        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: Helper.managedObjectContext!) as? Other
                        {
                            entity.lockOn = NSNumber(bool: lockSwitch.on)
                            entity.passwordHint =  passwordHint.text  //if else condition //using for hint
                            entity.password =  password.text
                            
                        }
                        do {
                            try Helper.managedObjectContext!.save()
                            Helper.passwordProtectionOn = true
                            Helper.password = password.text!
                            Helper.passwordHint = passwordHint.text!
                            FIRAnalytics.setUserPropertyString(Helper.passwordProtectionOn ?  "on" : "off", forName: "lock_status")
                            
                            
                            Helper.FIRAnalyticsLogEvent("app_lock_enabled", value: "app_lock_enabled")
                            
                            
                            
                            navigationController?.popViewControllerAnimated(true)
                        } catch let nsError as NSError{
                            Helper.fireBaseSetUserProperty(nsError)
                            //print("error")
                        }
                        
                        
                        
                    }
                }else{
                    error.text = "Confirm password does not match"
                }
            }
            else
            {
                error.text = "Password required"
            }
        }else{
            
            // save lock off
            
            let request = NSFetchRequest(entityName: "Other")
            
            
            
            if Helper.managedObjectContext!.countForFetchRequest( request , error: nil) > 0
            {
                
                do{
                    
                    
                    let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                    
                    queryResult.lockOn = NSNumber(bool: lockSwitch.on)
                    if let _ = queryResult.password
                    {
                        do {
                            try Helper.managedObjectContext!.save()
                            Helper.passwordProtectionOn = false
                            navigationController?.popViewControllerAnimated(true)
                        } catch let nsError as NSError{
                            Helper.fireBaseSetUserProperty(nsError)
                            //print("error")
                        }
                    }
                    
                    
                }
                catch let nsError as NSError{
                    Helper.fireBaseSetUserProperty(nsError)
                    //print("error : ", error)
                }
                
                
                
            }
            
        }
    }
    /*func validateEmail(candidate: String) -> Bool {
     let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
     return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
     }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        password.delegate  = self
        confirmPassword.delegate  = self
        passwordHint.delegate  = self
        lockSwitch.on = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddIncomeViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if lockSwitch.on
        {
            return true
        }
        else{
            return false
        }
    }
    /*func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
     if lockSwitch.on
     {
     return true
     }
     else{
     return false
     }
     
     }*/
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    override func viewWillAppear(animated: Bool) {
        let request = NSFetchRequest(entityName: "Other")
        
        if Helper.managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                
                if let _ = queryResult.password
                {
                    
                    lockSwitch.on = Bool(queryResult.lockOn!)
                    
                    password.text = queryResult.password
                    confirmPassword.text = queryResult.password
                    passwordHint.text = queryResult.passwordHint
                }
                
                
            }
            catch let nsError as NSError{
                Helper.fireBaseSetUserProperty(nsError)
                //print("error : ", error)
            }
            
            
            
        }
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
