//
//  ExpenseTable+CoreDataProperties.swift
//  budget
//
//  Created by Azam Rahmat on 9/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ExpenseTable {

    @NSManaged var amount: String?
    @NSManaged var createdAt: NSDate?
    @NSManaged var note: String?
    @NSManaged var reciept: NSData?
    @NSManaged var account: AccountTable?
    @NSManaged var subCategory: SubCategoryTable?

}
