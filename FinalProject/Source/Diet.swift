//
//  Diet.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/27/15.
//
//

import Foundation
import CoreData
import CoreDataService

class Diet: NSManagedObject, NamedEntity {

    // MARK: Properties (NamedEntity)
    static var entityName: String {
        return "Diet"
    }

}
