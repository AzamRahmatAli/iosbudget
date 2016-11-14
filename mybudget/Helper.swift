//
//  Helper.swift
//  budget
//
//  Created by Azam Rahmat on 8/12/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData
import UIKit


struct  Helper {
    static var pickCategory = false
    static var categoryPicked = false
    static var firstStart = true
    static var lockActivated = false
    static var passwordProtectionOn = false
    static var password = ""
    static let formatter = NSNumberFormatter()
   
    static var pickedSubCaregory : SubCategoryTable?
    static var expandedAndCollapsedSectionsIncome  : [Bool] = []
    static var expandedAndCollapsedSectionsAccount : [Bool] = []
    static var expandedAndCollapsedSectionsExpense : [Bool] = []
    static var datePic : NSDate? = nil
    static var pickAccount = false
    static var accountPicked = false
    
    static var pickedAccountData : AccountTable?
    static var bankIcon = "bank"
  
    
    static let colors: [UIColor] = [UIColor(red: 38/255, green: 151/255, blue: 213/255, alpha: 1),UIColor(red: 254/255, green: 129/255, blue: 0, alpha: 1),UIColor(red: 50/255, green: 195/255, blue: 0, alpha: 1),UIColor(red: 255/255, green: 33/255, blue: 67/255, alpha: 1),UIColor(red: 69/255, green: 68/255, blue: 205/255, alpha: 1)]
    
    static var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    static func getFormattedDate( date : NSDate ) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.stringFromDate(date)
        
    }
    static func saveChanges(context : NSManagedObjectContext, viewController : UIViewController)
    {
        do {
            try context.save()
            viewController.navigationController?.popViewControllerAnimated(true)
            
        } catch {
            print("error")
        }
    }
    
    static func getLocalCurrencySymbl(currencyCode : String) -> String
    {
        let locales: NSArray = NSLocale.availableLocaleIdentifiers()
        for localeID in locales as! [NSString] {
            let locale = NSLocale(localeIdentifier: localeID as String)
            let code = locale.objectForKey(NSLocaleCurrencyCode) as? String
            if code == currencyCode{
                print(currencyCode, localeID)
                
                let symbol = locale.objectForKey(NSLocaleCurrencySymbol) as? String
                print(symbol)
                return symbol!
                
            }
        }
        
        return  "$"
    }
    
    static func performUIUpdatesOnMain(updates: () -> Void) {
        dispatch_async(dispatch_get_main_queue()) {
            updates()
        }
        
        
    }
    static func addMenuButton(controller : UIViewController)
    {
    if  controller.revealViewController() != nil {
    //  menuButton.target = self.revealViewController()
    //  menuButton.action = "rightRevealToggle:"
    
    
    let myBtn: UIButton = UIButton()
    myBtn.setImage(UIImage(named: "menu"), forState: .Normal)
    myBtn.frame = CGRectMake(0, 0, 50, 50)
    myBtn.backgroundColor = UIColor.clearColor()
    // myBtn.addTarget(self, action: "rightRevealToggle:", forControlEvents: .TouchUpInside)
    myBtn.addTarget(controller.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    controller.navigationItem.setLeftBarButtonItem(UIBarButtonItem(customView: myBtn), animated: true)
    
    
  
    }

    }
    
}


extension Float {
    var asLocaleCurrency:String {
        
        return Helper.formatter.stringFromNumber(self)!
    }
    
    
}


