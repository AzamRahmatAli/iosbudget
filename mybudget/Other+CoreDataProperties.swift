//
//  Other+CoreDataProperties.swift
//  budget
//
//  Created by Azam Rahmat on 11/3/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Other {

    @NSManaged var oneBudget: String?
    @NSManaged var lockOn: NSNumber?
    @NSManaged var password: String?
    @NSManaged var email: String?
    @NSManaged var currencyCode: String?
    @NSManaged var currencySymbol: String?

}
