//
//  TransferTable+CoreDataProperties.swift
//  budget
//
//  Created by Azam Rahmat on 10/24/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TransferTable {

    @NSManaged var amount: String?
    @NSManaged var transferAt: NSDate?
    @NSManaged var fromAccount: AccountTable?
    @NSManaged var toAccount: AccountTable?

}
