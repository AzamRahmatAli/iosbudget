//
//  LockViewController.swift
//  budget
//
//  Created by Azam Rahmat on 11/2/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import LocalAuthentication
import Foundation
import UIKit
import MessageUI


class LockViewController: UIViewController , UITextFieldDelegate, MFMailComposeViewControllerDelegate{
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var appName: UILabel!
    
    /*override func viewDidLoad() {
     super.viewDidLoad()
     appName.text = StringFor.name["appName"]
     //print(password!)
     // Do any additional setup after loading the view.
     }*/
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        
        showPasswordHint()
        
    }
    
    
    func showPasswordHint() {
        
        
        Helper.alertUser(self, title: "Password Hint", message: "Your password hint is \"\(Helper.passwordHint)\" ")
        
    }
    
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        
        if (textField.text! + string) == Helper.password
        {
            Helper.lockActivated = false
            
            
            if Helper.firstStart
            {
                
                
                self.performSegueWithIdentifier("unlocked", sender: nil)
                Helper.firstStart = false
                
            }
            else{
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        
        return true
        
    }
    
    
    override func viewDidLoad() {
        
        Helper.lockActivated = true
        password.delegate = self
        appName.text = StringFor.name["appName"]
        
        
        
        
        
        let authContext : LAContext = LAContext()
        var error : NSError?
        if authContext.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error ){
            authContext.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentication is needed to access \(StringFor.name["appName"]!)", reply: { (wasSuccessful : Bool, error : NSError?) in
                Helper.performUIUpdatesOnMain()
                    {
                        if wasSuccessful
                        {
                            
                            Helper.lockActivated = false
                            
                            if Helper.firstStart
                            {
                                
                                
                                self.performSegueWithIdentifier("unlocked", sender: nil)
                                
                                Helper.firstStart = false
                                
                                
                            }
                            else{
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                                
                            }
                            
                        }
                        else{
                            
                            
                            self.password.becomeFirstResponder()
                        }
                }
            })
        }
        
        
        
        
    }
    
    
    
    
    
    
}
