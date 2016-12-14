//
//  BasicData.swift
//  budget
//
//  Created by Azam Rahmat on 10/14/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData
import Firebase

struct BasicData
{
    
    static let units = [
        Unit(name: "Home/Rent", image: "home",sname: ["Mortgage", "Mortgage-2nd","Rent", "Association fee", "Property tax"],simage: ["home", "home","home", "home", "home"]),
        
        Unit(name: "Utilities", image: "Utilities",sname: ["Electricity", "Gas/Heating","Telephone", "CellPhone", "Internet", "Cable/Dish", "Water", "Garbage"],simage: ["Utilities", "Gas","Telephone", "CellPhone", "Internet", "Cable", "Water", "Garbage"]),
        
        Unit(name: "Food/Groceries", image: "Food",sname: ["Groceries", "Restaurant/Fast food"], simage: ["Groceries", "Restaurant"]),
        
        Unit(name: "Departmental", image: "Departmental",sname: ["Clothing", "Personal Items", "Kids/Toys", "Books/Magazines"], simage: ["Clothing", "Departmental", "Kids", "Books"]),
        
        Unit(name: "Entertainment", image: "Entertainment",sname: ["Movies", "DVD rental", "Music"],simage: ["Movies", "DVD", "Entertainment"]),
        
        Unit(name: "Car/Auto", image: "car",sname: ["Gasoline", "Auto Loan", "Oil Change"],simage: ["car", "Auto", "Auto"]),
        
        Unit(name: "Insurance/Medical", image: "Insurance",sname: ["Insurance - Auto", "Insurance - Home", "Insurance - Medical", "Medical Expenses/Co-pay"],simage: ["Auto", "home", "Insurance", "Medical"]),
        
        Unit(name: "Misc/One-time", image: "Misc",sname: ["Air tickets", "Hotel/Lodging", "Gifts/Charity"],simage: ["Air", "Hotel", "Gifts"])
    ]
    
    
    
    
    
    
    struct Unit {
        let name: String
        let image: String
        let sname: [String]
        let simage: [String]
        
        
    }
    
    static func addBasicData()
    {
        if let managedObjectContext = Helper.managedObjectContext
        {
            for  key in units
            {
                for  (index, value) in key.sname.enumerate()
                {
                    if let expense = NSEntityDescription.insertNewObjectForEntityForName("SubCategoryTable", inManagedObjectContext: managedObjectContext) as? SubCategoryTable
                    {
                        
                        
                        expense.name = value
                        
                        
                        expense.icon = key.simage[index]
                        
                        
                        expense.category = CategoryTable.category(key.name, image: key.image,  inManagedObjectContext: managedObjectContext)
                        
                        
                        do{
                            try managedObjectContext.save()
                            
                            //for local currncy code and symbol
                            let formatter = NSNumberFormatter()
                            Helper.formatter.currencyCode =  formatter.currencyCode
                            Helper.formatter.currencySymbol = formatter.currencySymbol
                            //receivedMessageFromServer()
                            
                        }
                        catch let nsError as NSError{
          FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
                           //print("error")
                        }
                        
                        
                    }
                    else{
                       //print("fail insert")
                    }
                    
                }
            }
        }
    }
}