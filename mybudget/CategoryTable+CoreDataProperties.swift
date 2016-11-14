//
//  CategoryTable+CoreDataProperties.swift
//  budget
//
//  Created by Azam Rahmat on 8/29/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CategoryTable {

    @NSManaged var name: String?
    @NSManaged var icon: String?
    @NSManaged var subcategory: NSSet?

}
