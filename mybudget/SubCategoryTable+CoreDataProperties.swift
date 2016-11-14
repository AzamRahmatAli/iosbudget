//
//  SubCategoryTable+CoreDataProperties.swift
//  budget
//
//  Created by Azam Rahmat on 9/26/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SubCategoryTable {

    @NSManaged var amount: String?
    @NSManaged var icon: String?
    @NSManaged var name: String?
    @NSManaged var category: CategoryTable?
    @NSManaged var expense: NSSet?

}
