//
//  AccountTable.swift
//  budget
//
//  Created by Azam Rahmat on 8/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData


class AccountTable: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    class func account(name : String , type : String, inManagedObjectContext context: NSManagedObjectContext) -> AccountTable?
        
    {
        let request  = NSFetchRequest(entityName : "AccountTable")
        request.predicate = NSPredicate(format: "name = %@ AND accountType.name == %@", name, type)
        if let category = (try? context.executeFetchRequest(request))?.first as? AccountTable
        {
            
            return category
            
        }
        
        return nil
    }
}
