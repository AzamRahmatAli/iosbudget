//
//  Backup.swift
//  budget
//
//  Created by Azam Rahmat on 10/14/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData
import Firebase

struct Backup
{
static func doBackup() -> String?
{
    do{
        var fetchRequest = NSFetchRequest(entityName: "AccountTypeTable")
        
        
        var fetchedData : [AnyObject]? = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        var names : [String] = []
        
        for element in (fetchedData! as! [AccountTypeTable])
            
        {
            names.append(element.name!)
        }
        var dictionary : [String : AnyObject] = ["AccountTypeTable" : names]
        
        
        fetchRequest = NSFetchRequest(entityName: "CategoryTable")
        
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        var sets  = [[String:AnyObject]]()
        sets = []
        for element in (fetchedData! as! [CategoryTable])
            
        {
            sets.append(["name" :element.name!, "icon" :element.icon!])
        }
        dictionary["CategoryTable"] =  sets
        
        
        
        fetchRequest = NSFetchRequest(entityName: "AccountTable")
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        sets  = []
        for element in (fetchedData! as! [AccountTable])
            
        {
            sets.append(["name" :element.name!, "amount" :element.amount! , "icon" :element.icon! , "createdat" : String(element.createdAt!), "accounttype": element.accountType!.name!])
        }
        dictionary["AccountTable"] =  sets
        
        
        fetchRequest = NSFetchRequest(entityName: "SubCategoryTable")
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        sets  = []
        for element in (fetchedData! as! [SubCategoryTable])
            
        {
            sets.append(["name" :element.name!, "amount" :element.amount ?? "" , "icon" :element.icon! , "category": element.category!.name!])
        }
        dictionary["SubCategoryTable"] =  sets
        
        
        fetchRequest = NSFetchRequest(entityName: "IncomeTable")
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        sets  = []
        for element in (fetchedData! as! [IncomeTable])
            
        {
            sets.append(["name" :element.category!, "amount" :element.amount! , "note" :element.note! , "createdat" : String(element.createdAt!), "accountname" : element.account?.name ?? "", "accounttype" : element.account?.accountType?.name ?? ""])
        }
        dictionary["IncomeTable"] =  sets
        
        
        fetchRequest = NSFetchRequest(entityName: "ExpenseTable")
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        sets  = []
        for element in (fetchedData! as! [ExpenseTable])
            
        {
            var a : [String : AnyObject] = ["amount" :element.amount! , "note" :element.note!, "createdat" : String(element.createdAt!)]
            a["accountname"] = element.account?.name ?? ""
            a["accounttype"] =  element.account?.accountType?.name ?? ""
            a["subcategory"] = element.subCategory!.name!
            a["category"] = element.subCategory!.category!.name!
            if let reciept = element.reciept
            {
                let strBase64:String = reciept.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
                a["reciept"] = strBase64
            }
            else
            {
                a["reciept"] = ""
            }
            sets.append(a)
            
        }
        dictionary["ExpenseTable"] =  sets
        
        
        fetchRequest = NSFetchRequest(entityName: "Other")
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        sets  = []
        for element in (fetchedData! as! [Other])
            
        {
            var lockOn = ""
            if let lock = element.lockOn
            {
                lockOn = String(lock)
               //print(String(lock))
            }
           //print(String(NSDate()))
            sets.append(["currencyCode" :element.currencyCode ?? "" , "currencySymbol" :element.currencySymbol ?? "","oneBudget" :element.oneBudget ?? "" , "password" :element.password ?? "" , "passwordHint" :element.passwordHint ?? "" , "lockOn" : lockOn, "backupTime" : String(NSDate()) , "backupFrequency" : element.backupFrequency ?? ""])
           
            
        }
        dictionary["Other"] =  sets
        
        
        
        fetchRequest = NSFetchRequest(entityName: "TransferTable")
        fetchedData = try Helper.managedObjectContext?.executeFetchRequest(fetchRequest)
        sets  = []
        for element in (fetchedData! as! [TransferTable])
            
        {
            sets.append(["transferAt" : String(element.transferAt!), "amount" :element.amount ?? "" , "fromAccountname" : element.fromAccount?.name ?? "", "fromAccounttype" : element.fromAccount?.accountType?.name ?? "" , "toAccountname" : element.toAccount?.name ?? "", "toAccounttype" : element.toAccount?.accountType?.name ?? ""])
        }
        dictionary["TransferTable"] =  sets
        
        /*let dataInArr:NSArray = ManagedParser.convertToArray(fetchedGuest);
         NSLog("dataInArr \(dataInArr)");*/
        
        
        let jsonData: NSData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions.PrettyPrinted)
        let cdata = NSString(data: jsonData, encoding: NSUTF8StringEncoding)! as String
        ////print(cdata)
        /*if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
         let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent("datafile.txt")
         /*if let file = NSFileHandle(forWritingAtPath:"datafile.txt") {
         file.writeData(jsonData)
         }*/
         //writing
         do {
         try cdata.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
         
         }
         catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")/* error handling here */}
         }*/
        
        return cdata
        // let myEntities : [String] = Array(objectModel!.entitiesByName.keys)
        ////print(myEntities)
        
    }
    catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
       //print("error : ", error)
    }
    return nil
}
 

    
    
    

}
