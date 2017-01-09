//
//  Diet+CoreDataProperties.swift
//  FinalProject
//
//  Created by Joy Hurburt on 12/10/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Diet {

    @NSManaged var index: NSNumber?
    @NSManaged var name: String?
    @NSManaged var selected: NSNumber?

}
