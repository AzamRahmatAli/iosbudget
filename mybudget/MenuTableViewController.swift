//
//  MenuTableViewController.swift
//  H&H
//
//  Created by Azad on 19/03/2016.
//  Copyright © 2016 Azad. All rights reserved.
//

import UIKit
import CoreData



class MenuTableViewController: UITableViewController {
    
    // @IBOutlet weak var cellAsButton: UIButton!
    
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var help: UIImageView!
    
    @IBOutlet weak var setting: UIImageView!
    
    @IBOutlet weak var dashBoard: UIImageView!
    @IBOutlet weak var quickSummary: UIImageView!
    //@IBOutlet weak var currency: UILabel!
    
    @IBOutlet weak var available: UILabel!
    
    
    @IBOutlet weak var needle: UIImageView!
    @IBOutlet weak var percentageText: UILabel!
    @IBOutlet weak var percentage: UILabel!
    var ExpenceAsPercentage : CGFloat = 0
    
    @IBOutlet weak var meterView: UIView!
    
    
    
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.view.frame.size.height == 480
        {
            percentageText.hidden = true
            meterView.hidden = true
        }
        
        
        switchColor(1)
        appName.text = StringFor.name["appName"]!
        
        // cellAsButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func switchColor(index : Int)
    {
        dashBoard.tintColor = UIColor.lightGrayColor()
        quickSummary.tintColor = UIColor.lightGrayColor()
        setting.tintColor = UIColor.lightGrayColor()
        help.tintColor = UIColor.lightGrayColor()
        if index == 1
        {
            dashBoard.tintColor = Helper.colors[0]//UIColor(red: 0, green : 0.478431, blue: 1 , alpha: 1)
        }else if index == 2
        {
            quickSummary.tintColor = Helper.colors[0]
        }
        else if index == 3
        {
            setting.tintColor = Helper.colors[0]
        }
        else if index == 4
        {
            help.tintColor = Helper.colors[0]
        }
    }
    /*override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
     
     
     if(indexPath.row == 0)
     {
     
     
     }
     
     
     if(indexPath.row == 1)
     {
     
     
     }
     if(indexPath.row == 2)
     {
     
     cell.detailTextLabel?.text = "PKR"
     }
     return cell
     }*/
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0)
        {
            
        }
        if(indexPath.row == 1)
        {
            self.performSegueWithIdentifier("dashboard", sender: nil)
            switchColor(indexPath.row)
        }
        else if(indexPath.row == 2)
        {/*
             Helper.performUIUpdatesOnMain
             {
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             
             let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("currency") as! UINavigationController
             self.presentViewController(nextViewController, animated:true, completion:nil)
             
             }*/
            
            switchColor(indexPath.row)
            
        }
        else if(indexPath.row == 3)
        {
            /*Helper.performUIUpdatesOnMain
             {
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             
             let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("emailBackup") as! UINavigationController
             self.presentViewController(nextViewController, animated:true, completion:nil)
             
             }*/
            switchColor(indexPath.row)
            
        }
        else if(indexPath.row == 4)
        {/*
             Helper.performUIUpdatesOnMain
             {
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             
             let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("settings") as! UINavigationController
             self.presentViewController(nextViewController, animated:true, completion:nil)
             
             }*/
            switchColor(indexPath.row)
            Helper.alertUser(self, title: "Help", message: "\(StringFor.name["appName"]!) provide features to manage your cash flow.\n\(StringFor.name["appName"]!) supports tracking of expenses, income, budgets and accounts.\nWe welcome your suggestions and feedback. Contact us at: \(StringFor.name["email"]!).")
            
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //currency.text = Helper.formatter.currencyCode
        if Helper.totalBudget == 0
        {
            available.text = (Helper.totalIncome -  Helper.totalExpenses).asLocaleCurrency
            percentageText.text = "Expenses as % of Income"
            var pt = 0
            if Helper.totalIncome != 0 // to solve infinity problem
            {
                pt = Int((Helper.totalExpenses / Helper.totalIncome) * 100)
            }else if Helper.totalExpenses > 0
            {
                pt = 101 // to solve 100+ problem
            }
            percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
            ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
        }
        else{
            
            available.text = (Helper.totalBudget -  Helper.totalExpenses).asLocaleCurrency
            percentageText.text = "Expenses as % of Budget"
            var pt = 0
            if Helper.totalBudget != 0
            {
                pt = Int((Helper.totalExpenses / Helper.totalBudget) * 100)
            }else if Helper.totalExpenses > 0
            {
                pt = 100
            }
            percentage.text =  pt > 100 ? (String(100) + "%+") : (String(pt) + "%")
            ExpenceAsPercentage = pt > 100 ? CGFloat(100) : CGFloat(pt)
            
        }
        
        
        UIView.animateWithDuration(1.0, animations: {
            self.needle.layer.anchorPoint = CGPointMake(0.5, 0.54)
            let ValueToMinus = (self.ExpenceAsPercentage < 30 ) ? ((self.ExpenceAsPercentage + 9)/100) * 24 : (self.ExpenceAsPercentage/100) * 24
            
            let angle = ((self.ExpenceAsPercentage - ValueToMinus)  / 100 ) * CGFloat(2 * M_PI)
            self.needle.transform = CGAffineTransformMakeRotation(angle)
            //print(angle,CGFloat(2 * M_PI))
            
        })
        
    }
    
    
    
}
/*
 class ManagedParser: NSObject {
 static  var parsedObjs:NSMutableSet = NSMutableSet();
 
 class func convertToArray(managedObjects:NSArray?, parentNode:String? = nil) -> NSArray {
 let rtnArr:NSMutableArray = NSMutableArray();
 //--
 if let managedObjs:[NSManagedObject] = managedObjects as? [NSManagedObject] {
 for managedObject:NSManagedObject in managedObjs {
 if self.parsedObjs.member(managedObject) == nil {
 self.parsedObjs.addObject(managedObject);
 rtnArr.addObject(self.convertToDictionary(managedObject, parentNode: parentNode));
 }
 }
 }
 
 return rtnArr;
 } //F.E.
 
 class func convertToDictionary(managedObject:NSManagedObject, parentNode:String? = nil) -> NSDictionary {
 let rtnDict:NSMutableDictionary = NSMutableDictionary();
 //-
 let entity:NSEntityDescription = managedObject.entity;
 let properties:[String] = (entity.propertiesByName as NSDictionary).allKeys as? [String] ?? [];
 //--
 let parentNode:String = parentNode ?? managedObject.entity.name!;
 for property:String in properties  {
 if (property.caseInsensitiveCompare(parentNode) != NSComparisonResult.OrderedSame)
 {
 let value: AnyObject? = managedObject.valueForKey(property);
 //--
 if let set:NSSet = value as? NSSet {
 rtnDict[property] = self.convertToArray(set.allObjects, parentNode: parentNode);
 } else if let orderedset:NSOrderedSet = value as? NSOrderedSet {
 rtnDict[property] = self.convertToArray(NSArray(array: orderedset.array), parentNode: parentNode);
 } else if let vManagedObject:NSManagedObject = value as? NSManagedObject {
 if self.parsedObjs.member(managedObject) == nil {
 self.parsedObjs.addObject(managedObject);
 if (vManagedObject.entity.name != parentNode) {
 rtnDict[property] = self.convertToDictionary(vManagedObject, parentNode: parentNode);
 }
 }
 } else  if let vData:AnyObject = value {
 rtnDict[property] = vData;
 }
 }
 }
 
 return rtnDict;
 } //F.E.
 
 
 } //CLS END*/
