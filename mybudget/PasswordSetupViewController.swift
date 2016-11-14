//
//  PasswordSetupViewController.swift
//  budget
//
//  Created by Azam Rahmat on 11/3/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class PasswordSetupViewController: UIViewController , UITextFieldDelegate{
    @IBOutlet weak var lockSwitch: UISwitch!
    
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var error: UILabel!
    @IBAction func save(sender: UIBarButtonItem) {
        dismissKeyboard()
        if lockSwitch.on
        {
            if password.text != ""
            {
                if confirmPassword.text == password.text
                {
                    if email.text == ""
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
                                    queryResult.email = email.text
                                    queryResult.password =  password.text
                                    
                                }
                                catch let error {
                                    print("error : ", error)
                                }
                                
                                
                                
                            }
                                
                            else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: Helper.managedObjectContext!) as? Other
                            {
                                entity.lockOn = NSNumber(bool: lockSwitch.on)
                                entity.email =  email.text  //if else condition
                                entity.password =  password.text
                                
                            }
                            do {
                                try Helper.managedObjectContext!.save()
                                Helper.passwordProtectionOn = true
                                Helper.password = password.text!
                                navigationController?.popViewControllerAnimated(true)
                            } catch {
                                print("error")
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
                        } catch {
                            print("error")
                        }
                    }
                    
                    
                }
                catch let error {
                    print("error : ", error)
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
        email.delegate  = self
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
                    email.text = queryResult.email
                }
                
                
            }
            catch let error {
                print("error : ", error)
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
