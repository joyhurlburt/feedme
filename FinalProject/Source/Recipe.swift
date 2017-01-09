//
//  Recipe.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/18/15.
//
//

import Foundation
import CoreData
import CoreDataService

class Recipe: NSManagedObject, NamedEntity {

    // MARK: Properties (NamedEntity)
    static var entityName: String {
        return "Recipe"
    }

}
