//
//  Recipe+CoreDataProperties.swift
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

extension Recipe {

    @NSManaged var hostedSmallUrl: NSData?
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var sourceRecipeUrl: String?
    @NSManaged var totalTime: String?
    @NSManaged var yield: String?
    @NSManaged var hostedLargeUrl: NSData?
    @NSManaged var ingredients: NSSet?

}
