//
//  AccountTypeTable.swift
//  budget
//
//  Created by Azam Rahmat on 8/29/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData


class AccountTypeTable: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func accontType(accountType : String, inManagedObjectContext context: NSManagedObjectContext) -> AccountTypeTable?
        
    {
        let request  = NSFetchRequest(entityName : "AccountTypeTable")
        request.predicate = NSPredicate(format: "name = %@", accountType)
        if let accountTyp = (try? context.executeFetchRequest(request))?.first as? AccountTypeTable
        {
            return accountTyp
            
        }else if let accountTyp = NSEntityDescription.insertNewObjectForEntityForName("AccountTypeTable", inManagedObjectContext: context) as? AccountTypeTable
        {
            accountTyp.name = accountType
            
            return accountTyp
        }
        
        
        return nil
    }

}
