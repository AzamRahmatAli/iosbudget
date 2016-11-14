//
//  SubCategoryTable.swift
//  budget
//
//  Created by Azam Rahmat on 8/29/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData


class SubCategoryTable: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
   
    class func subCategory(name : String , categoryName : String, inManagedObjectContext context: NSManagedObjectContext) -> SubCategoryTable?
        
    {
        let request  = NSFetchRequest(entityName : "SubCategoryTable")
        request.predicate = NSPredicate(format: "name = %@ AND category.name == %@", name, categoryName)
        if let category = (try? context.executeFetchRequest(request))?.first as? SubCategoryTable
        {
            
            return category
            
        }
        
        return nil
    }
    
    class func subcategory(name : String, image : String, categoryName : String, inManagedObjectContext context: NSManagedObjectContext) -> SubCategoryTable?
        
    {
        let request  = NSFetchRequest(entityName : "SubCategoryTable")
        request.predicate = NSPredicate(format: "name = %@ AND category.name == %@", name, categoryName)
        if let category = (try? context.executeFetchRequest(request))?.first as? SubCategoryTable
        {
             //if user add same subcategory name
            return category
            
        }else if let category = NSEntityDescription.insertNewObjectForEntityForName("SubCategoryTable", inManagedObjectContext: context) as? SubCategoryTable
        {
            category.name = name
            category.icon = image
            
            category.category = CategoryTable.categoryByOnlyName(categoryName, inManagedObjectContext: context)
            return category
        }
        
        
        return nil
    }
}
