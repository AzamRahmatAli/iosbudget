//
//  Restore.swift
//  budget
//
//  Created by Azam Rahmat on 10/14/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData

struct Restore
{
    
    
    
     static func restoreBackup(fileName : String) -> Bool
    {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let dir = CloudDataManager.DocumentsDirectory.iCloudDocumentsURL!
        //if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        let path = dir.URLByAppendingPathComponent(fileName)
        do {
            let data = NSData(contentsOfURL : path) as NSData!
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            if let dic = json as? [String : AnyObject]
            {
                if let accountTypes = dic["AccountTypeTable"]
                {
                    if let names = accountTypes as? [String]
                    {
                        for name in names{
                            
                            AccountTypeTable.accontType(name, inManagedObjectContext: Helper.managedObjectContext!)
                        }
                    }
                }
                
                if let records = dic["AccountTable"]
                {
                    if let accounts =  records  as? [[String : String]]
                    {
                        for account in accounts{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("AccountTable", inManagedObjectContext: Helper.managedObjectContext!) as? AccountTable
                            {
                                
                                
                                
                                entity.amount = account["amount"]
                                entity.icon = account["icon"]
                                
                                entity.name = account["name"]
                                let dateString = account["createdat"]
                                
                                //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
                                let dateObj = dateFormatter.dateFromString(dateString!)
                                print(dateObj)
                                entity.createdAt = dateObj
                                entity.accountType = AccountTypeTable.accontType(account["accounttype"]!, inManagedObjectContext: Helper.managedObjectContext!)
                                
                                
                                
                                
                            }
                        }
                    }
                }
                if let records = dic["CategoryTable"]
                {
                    if let data =  records  as? [[String : String]]
                    {
                        for element in data{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("CategoryTable", inManagedObjectContext: Helper.managedObjectContext!) as? CategoryTable
                            {
                                
                                entity.name = element["name"]
                                entity.icon = element["icon"]
                                
                                
                            }
                        }
                    }
                }
                if let records = dic["Other"]
                {
                    if let data =  records  as? [[String : String]]
                    {
                        for element in data{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: Helper.managedObjectContext!) as? Other
                            {
                                if element["email"]  != ""
                                {
                                    entity.email = element["email"]
                                }
                                if element["password"]  != ""
                                {
                                    entity.password = element["password"]
                                }
                                if element["lockOn"]  != ""
                                {
                                    entity.lockOn = element["lockOn"] == "1" ? true : false
                                }
                                if element["oneBudget"]  != ""
                                {
                                    entity.oneBudget = element["oneBudget"]
                                }
                                
                                
                            }
                        }
                    }
                }
                if let records = dic["SubCategoryTable"]
                {
                    if let data =  records  as? [[String : String]]
                    {
                        for element in data{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("SubCategoryTable", inManagedObjectContext: Helper.managedObjectContext!) as? SubCategoryTable
                            {
                                
                                entity.name = element["name"]
                                entity.icon = element["icon"]
                                if element["amount"] != ""
                                {
                                    entity.amount = element["amount"]
                                }
                                
                                entity.category = CategoryTable.categoryByOnlyName(element["category"]!, inManagedObjectContext: Helper.managedObjectContext!)
                            }
                        }
                    }
                }
                if let records = dic["IncomeTable"]
                {
                    if let data =  records  as? [[String : String]]
                    {
                        for element in data{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("IncomeTable", inManagedObjectContext: Helper.managedObjectContext!) as? IncomeTable
                            {
                                
                                entity.category = element["name"]
                                entity.note = element["note"]
                                if element["amount"] != ""
                                {
                                    entity.amount = element["amount"]
                                }
                                let dateString = element["createdat"]
                                
                                let dateObj = dateFormatter.dateFromString(dateString!)
                                
                                entity.createdAt = dateObj
                                if element["accountname"] != ""
                                {
                                    
                                    
                                    entity.account = AccountTable.account(element["accountname"]!, type: element["accounttype"]!, inManagedObjectContext: Helper.managedObjectContext!)
                                }
                            }
                        }
                    }
                }
                if let records = dic["ExpenseTable"]
                {
                    if let data =  records  as? [[String : String]]
                    {
                        for element in data{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("ExpenseTable", inManagedObjectContext: Helper.managedObjectContext!) as? ExpenseTable
                            {
                                if element["reciept"] != ""
                                {
                                    let dataDecoded:NSData = NSData(base64EncodedString: element["reciept"]!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
                                    entity.reciept = dataDecoded
                                }
                                entity.note = element["note"]
                                if element["amount"] != ""
                                {
                                    entity.amount = element["amount"]
                                }
                                let dateString = element["createdat"]
                                
                                let dateObj = dateFormatter.dateFromString(dateString!)
                                
                                entity.createdAt = dateObj
                                if element["accountname"] != ""
                                {
                                    
                                    
                                    entity.account = AccountTable.account(element["accountname"]!, type: element["accounttype"]!, inManagedObjectContext: Helper.managedObjectContext!)
                                }
                                
                                
                                entity.subCategory = SubCategoryTable.subCategory(element["subcategory"]!, categoryName: element["category"]!, inManagedObjectContext: Helper.managedObjectContext!)
                                
                            }
                        }
                    }
                }
                if let records = dic["TransferTable"]
                {
                    if let data =  records  as? [[String : String]]
                    {
                        for element in data{
                            
                            if let entity = NSEntityDescription.insertNewObjectForEntityForName("TransferTable", inManagedObjectContext: Helper.managedObjectContext!) as? TransferTable
                            {
                                let dateString = element["transferAt"]
                                
                                let dateObj = dateFormatter.dateFromString(dateString!)
                                
                                entity.transferAt = dateObj
                                
                                
                                
                                if element["amount"] != ""
                                {
                                    entity.amount = element["amount"]
                                }
                                if element["fromAccountname"] != ""
                                {
                                    
                                    
                                    entity.fromAccount = AccountTable.account(element["fromAccountname"]!, type: element["fromAccounttype"]!, inManagedObjectContext: Helper.managedObjectContext!)
                                }
                                if element["toAccountname"] != ""
                                {
                                    
                                    
                                    entity.toAccount = AccountTable.account(element["toAccountname"]!, type: element["toAccounttype"]!, inManagedObjectContext: Helper.managedObjectContext!)
                                }
                               


                                
                            }
                        }
                    }
                }
                
                do {
                    try Helper.managedObjectContext!.save()
                    return true
                    
                } catch {
                    print("error")
                }
             
            }
            print(json)
            
            
            
        }
        catch {/* error handling here */}
        return false
    }
    
    private static func clearCoreData() -> Bool
    {
        let objectModel : NSManagedObjectModel? =  (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectModel
        
        let entities = objectModel!.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest(entityName: entity.name!)
            let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try Helper.managedObjectContext!.executeRequest(deleteReqest)
                
            } catch {
                print(error)
                return false
            }
            
        }
        return true
    }
    
    static func clearCoreDataStore() -> Bool{
            if clearCoreData()
            {
        do {
            try Helper.managedObjectContext!.save()
            return true
            
            
            
        } catch {
            print("error")
        }
        }
        return false
    }
    
    
    static func fullReset()
    {
        if clearCoreData()
        {
        do {
            try Helper.managedObjectContext!.save()
            
            BasicData.addBasicData()
            
        } catch {
            print("error")
        }
    }
    }
}

