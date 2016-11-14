//
//  CategoryTable.swift
//  budget
//
//  Created by Azam Rahmat on 8/29/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData


class CategoryTable: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func category(name : String, image : String, inManagedObjectContext context: NSManagedObjectContext) -> CategoryTable?
        
    {
        let request  = NSFetchRequest(entityName : "CategoryTable")
         request.predicate = NSPredicate(format: "name = %@", name)
         if let category = (try? context.executeFetchRequest(request))?.first as? CategoryTable
         {
        //if user add same category name
         return category
         
         }else if let category = NSEntityDescription.insertNewObjectForEntityForName("CategoryTable", inManagedObjectContext: context) as? CategoryTable
         {
            category.name = name
            category.icon = image
            
            
            return category
        }
        
        
        return nil
    }
    class func categoryByOnlyName(name : String , inManagedObjectContext context: NSManagedObjectContext) -> CategoryTable?
        
    {
        let request  = NSFetchRequest(entityName : "CategoryTable")
        request.predicate = NSPredicate(format: "name = %@", name)
        if let category = (try? context.executeFetchRequest(request))?.first as? CategoryTable
        {
            return category
            
        }
        
        
        return nil
    }

}
