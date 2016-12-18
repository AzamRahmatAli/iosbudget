//
//  Currency.swift
//  budget
//
//  Created by Azam Rahmat on 10/14/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData
import Firebase

struct Currency {
    
    let code, displayName: String
    
    init?(code: String?) {
        if let code = code,
            displayName = NSLocale.currentLocale().displayNameForKey(NSLocaleCurrencyCode, value:code) {
           
            self.code = code
            self.displayName = displayName
        } else {
            return nil
        }
    }
    
    static func saveCurrencyCodeAndSymbol()
    {
        let request = NSFetchRequest(entityName: "Other")
       
        
        if Helper.managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                
                let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                queryResult.currencyCode = Helper.formatter.currencyCode
                queryResult.currencySymbol = Helper.formatter.currencySymbol
                
                
            }
            catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
               //print("error : ", error)
            }
            
            
            
        }
            
        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: Helper.managedObjectContext!) as? Other
        {
            
            entity.currencyCode =  Helper.formatter.currencyCode
            entity.currencySymbol =  Helper.formatter.currencySymbol
            
        }
        do {
            try Helper.managedObjectContext!.save()
            
            
        } catch let nsError as NSError{
          Helper.fireBaseSetUserProperty(nsError)
           //print("error")
        }
    }

}

struct CurrencyDataSource {
    
    let currencies: [Currency] = {
        // The first `map` can be replaced with `flatMap` in Swift 2.0
        // to remove the `filter` and `map` calls afterwards
        NSLocale.commonISOCurrencyCodes().map {
            return Currency(code: $0 )
            }.filter { $0 != nil }.map { $0! }
    }()
    
    
    
}
