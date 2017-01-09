//
//  RecipeService.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/5/15.
//
//

import Foundation
import CoreData
import CoreDataService

class RecipeService {
    
    func searchRecipes(completionHandler: (error: NSError?) -> Void) {
        RecipeDataEndpoint().searchRecipes(completionHandler)
    }
    
    func getRecipe(recipe: Recipe, completionHandler: (error: NSError?) -> Void) {
        RecipeDataEndpoint().getRecipe(recipe, completionHandler: completionHandler)
    }
    
    func diets() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: Diet.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            print("Error: performFetch() failed")
        }
        return controller
    }
    
    func updateDiet(name: String, selected: Bool) -> Bool {
        var flag: Bool
        
        let fetchRequest = NSFetchRequest(namedEntity: Diet.self)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Diet]
            fetchedEntities.first?.selected = selected
            flag = true
        } catch {
            print("Error: executeFetchRequest() failed")
            flag = false
        }
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                print("Successfully updated \(name) diet to \(selected)")
            })
            flag = true
        } catch let error {
            flag = false
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")        }
        
        return flag
    }
    
    func recipes() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: Recipe.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            print("Error: performFetch() failed")
        }
        return controller
    }
    
    func updateRecipe(name: String, totalTime: String, yield: String, sourceRecipeUrl: String, hostedLargeUrl: NSData) -> Bool {
        var flag: Bool
        
        let fetchRequest = NSFetchRequest(namedEntity: Recipe.self)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Recipe]
            fetchedEntities.first?.totalTime = totalTime
            fetchedEntities.first?.yield = yield
            fetchedEntities.first?.sourceRecipeUrl = sourceRecipeUrl
            fetchedEntities.first?.hostedLargeUrl = hostedLargeUrl
            flag = true
        } catch {
            print("Error: executeFetchRequest() failed")
            flag = false
        }
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                print("Successfully updated \(name) recipe")
            })
            flag = true
        } catch let error {
            flag = false
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
        }
        
        return flag
    }
    
    func clearRecipes() throws -> Bool {
        var flag : Bool
        
        let fetchRequest = NSFetchRequest(namedEntity: Recipe.self)
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        if let recipes = (try? context.executeFetchRequest(fetchRequest)) as? Array<Recipe> {
            for recipe in recipes {
                context.deleteObject(recipe)
                flag = true
            }
        }
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext { () -> Void in
                print("Finished clearing recipe data")
            }
            flag = true
        } catch let error {
            flag = false
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
        }
        
        return flag
        
    }
    
    func ingredients() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: Ingredient.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            print("Error: performFetch() failed")
        }
        return controller
    }
    
    func addIngredient(name: String) -> NSManagedObject {
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        
        let ingredient = NSEntityDescription.insertNewObjectForNamedEntity(Ingredient.self, inManagedObjectContext: context)
        ingredient.name = name
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                print("Successfully saved \(ingredient.name!) ingredient")
            })
        } catch let error {
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
        }
        
        return ingredient
    }
    
    func updateIngredient(name: String, checked: Bool) -> Bool {
        var flag : Bool
        
        let fetchRequest = NSFetchRequest(namedEntity: Ingredient.self)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Ingredient]
            fetchedEntities.first?.checked = checked
            flag = true
        } catch {
            print("Error: executeFetchRequest() failed")
            flag = false
        }
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                print("Successfully updated \(name) ingredient to \(checked)")
            })
            flag = true
        } catch let error {
            flag = false
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
        }
        
        return flag
    }
    
    func deleteIngredient(object: NSManagedObject) -> Bool {
        var flag: Bool
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        context.deleteObject(object)
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                print("Successfully deleted ingredient")
            })
            flag = true
        } catch let error {
            flag = false
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
        }
        
        return flag
    }
    
    func photos() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: Photo.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try controller.performFetch()
        } catch {
            print("Error: performFetch() failed")
        }
        return controller
    }
    
    func addPhoto(imageData: NSData) -> NSManagedObject {
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        let photo = NSEntityDescription.insertNewObjectForNamedEntity(Photo.self, inManagedObjectContext: context)
        photo.imageData = imageData
        
        do {
            try context.save()
            CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                print("Successfully saved photo")
            })
        } catch let error {
            fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
        }
        
        return photo
    }
    
    // MARK: Endpoint
    func lookupRecipeWithName(name: String, inContext context: NSManagedObjectContext) -> Recipe? {
        let fetchRequest = NSFetchRequest(namedEntity: Recipe.self)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let results = try? context.executeFetchRequest(fetchRequest)
        return results?.first as? Recipe
    }
    
    func lookupIngredientWithName(name: String, inContext context: NSManagedObjectContext) -> Ingredient? {
        let fetchRequest = NSFetchRequest(namedEntity: Ingredient.self)
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        let results = try? context.executeFetchRequest(fetchRequest)
        return results?.first as? Ingredient
    }
    
    // MARK: Initialization
    private init() {
        let dietFetchRequest = NSFetchRequest(namedEntity: Diet.self)
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let dietCount = context.countForFetchRequest(dietFetchRequest, error: nil)
        
        if dietCount == 0 {
            let diets = ["Pescetarian", "Vegetarian", "Vegan", "Gluten-Free", "Dairy-Free", "Nut-Free", "Peanut-Free"]
            
            for var i = 0; i < diets.count; i++ {
                let dietObject = NSEntityDescription.insertNewObjectForNamedEntity(Diet.self, inManagedObjectContext: context)
                dietObject.name = diets[i]
                dietObject.selected = false
                dietObject.index = i
            }
            
            do {
                try context.save()
                CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                    print("Initial diet data persisted")
                })
            } catch let error {
                fatalError("Failed to save main queue context after creating initial content \(error as NSError)")
            }
        }
        
    }
    
    // MARK: Properties (Static)
    static let sharedRecipeService = RecipeService()
    
}