//
//  Other+CoreDataProperties.swift
//  mybudget
//
//  Created by Azam Rahmat on 12/11/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Other {

    @NSManaged var backupFrequency: String?
    @NSManaged var backupTime: NSDate?
    @NSManaged var currencyCode: String?
    @NSManaged var currencySymbol: String?
    @NSManaged var passwordHint: String?
    @NSManaged var lockOn: NSNumber?
    @NSManaged var oneBudget: String?
    @NSManaged var password: String?

}
