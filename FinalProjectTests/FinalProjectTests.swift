//
//  FinalProjectTests.swift
//  FinalProjectTests
//
//  Created by Joy Hurlburt.
//
//

import XCTest
import CoreData
import CoreDataService
@testable import FinalProject

class FinalProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testCoreDataServiceMainQueueContextExists() {
        let recipeService = RecipeService.sharedRecipeService
        XCTAssertNotNil(recipeService, "RecipeService singleton should not be nil")
    }
    
    func testDietsResultsControllerExists() {
        let resultsController = RecipeService.sharedRecipeService.diets()
        XCTAssertNotNil(resultsController, "RecipeService NSFetchedResultsController should not be nil")
    }
    
    func testDietsPerformFetchExists() {
        let resultsController = RecipeService.sharedRecipeService.diets()
        XCTAssertNotNil(try! resultsController.performFetch(), "RecipeService perfromFetch() should not be nil")
    }
    
    func testDietsResultsControllerSectionsExists() {
        let resultsController = RecipeService.sharedRecipeService.diets()
        try! resultsController.performFetch()
        
        if let sectionCount = resultsController.sections?.count {
            XCTAssertGreaterThan(sectionCount, 0, "Diets NSFetchedResultsController should contain more than 0 sections")
        } else {
            XCTFail("Diets NSFetchedResultsController doesn't contain more than 0 sections")
        }
    }
    
    func testDietsResultsControllerSectionItemsExists() {
        let resultsController = RecipeService.sharedRecipeService.diets()
        try! resultsController.performFetch()
        
        if let sections = resultsController.sections {
            for section in sections {
                let itemCount = section.numberOfObjects
                XCTAssertGreaterThan(itemCount, 0, "Diets NSFetchedResultsController section(s) should contain more than 0 items")
            }
        }
    }
    
    func testUpdateDietFunction() {
        let flag: Bool
        flag = RecipeService.sharedRecipeService.updateDiet("Vegan", selected: true)
        XCTAssertTrue(flag, "RecipeService updateDiet() should return true")
    }
    
    func testRecipesResultsControllerExists() {
        let resultsController = RecipeService.sharedRecipeService.recipes()
        XCTAssertNotNil(resultsController, "RecipeService NSFetchedResultsController should not be nil")
    }
    
    func testRecipesPerformFetchExists() {
        let resultsController = RecipeService.sharedRecipeService.recipes()
        XCTAssertNotNil(try! resultsController.performFetch(), "RecipeService perfromFetch() should not be nil")
    }
    
    func testRecipesResultsControllerSectionsExists() {
        let resultsController = RecipeService.sharedRecipeService.recipes()
        try! resultsController.performFetch()
        
        if let sectionCount = resultsController.sections?.count {
            XCTAssertGreaterThan(sectionCount, 0, "Recipes NSFetchedResultsController should contain more than 0 sections")
        } else {
            XCTFail("Recipes NSFetchedResultsController doesn't contain more than 0 sections")
        }
    }
    
    func testUpdateRecipeFunction() {
        let flag: Bool
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let recipe = NSEntityDescription.insertNewObjectForNamedEntity(Recipe.self, inManagedObjectContext: context)
        
        let name = "Recipe Name"
        let image = UIImage(named: "MealPlan")
        let largeImage = UIImage(named: "MealPlan")
        
        recipe.name = name
        recipe.hostedSmallUrl = NSData(data: UIImagePNGRepresentation(image!)!)
        recipe.id = "Recipe-Id"
        recipe.totalTime = "totalTime"
        recipe.yield = "yield"
        recipe.sourceRecipeUrl = "sourceRecipeUrl"
        recipe.hostedLargeUrl = NSData(data: UIImagePNGRepresentation(largeImage!)!)
        
        let totalTime = "totalTime"
        let yield = "yield"
        let sourceRecipeUrl = "sourceRecipeUrl"
        let hostedLargeUrl = NSData(data: UIImagePNGRepresentation(largeImage!)!)
        
        flag = RecipeService.sharedRecipeService.updateRecipe(name, totalTime: totalTime, yield: yield, sourceRecipeUrl: sourceRecipeUrl, hostedLargeUrl: hostedLargeUrl)
        XCTAssertTrue(flag, "RecipeService updateRecipe() should return true")
    }
    
    func testIngredientsResultsControllerExists() {
        let resultsController = RecipeService.sharedRecipeService.ingredients()
        XCTAssertNotNil(resultsController, "RecipeService NSFetchedResultsController should not be nil")
    }
    
    func testIngredientsPerformFetchExists() {
        let resultsController = RecipeService.sharedRecipeService.ingredients()
        XCTAssertNotNil(try! resultsController.performFetch(), "RecipeService perfromFetch() should not be nil")
    }
    
    func testIngredientsResultsControllerSectionsExists() {
        let resultsController = RecipeService.sharedRecipeService.ingredients()
        try! resultsController.performFetch()
        
        if let sectionCount = resultsController.sections?.count {
            XCTAssertGreaterThan(sectionCount, 0, "Ingredients NSFetchedResultsController should contain more than 0 sections")
        } else {
            XCTFail("Ingredients NSFetchedResultsController doesn't contain more than 0 sections")
        }
    }
    
    func testAddIngredientFunction() {
        let ingredient = "Apple"
        let ingredientObject = RecipeService.sharedRecipeService.addIngredient(ingredient) as! Ingredient
        XCTAssertEqual(ingredient, ingredientObject.name, "RecipeService addIngredient should return ingredient object")
    }
    
    func testUpdateIngredientFunction() {
        let flag: Bool
        flag = RecipeService.sharedRecipeService.updateIngredient("Apple", checked: true)
        XCTAssertTrue(flag, "RecipeService updateIngredient should return true")
    }
    
    func testDeleteIngredientFunction() {
        let flag: Bool
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let ingredientObject = RecipeService.sharedRecipeService.lookupIngredientWithName("Apple", inContext: context)
        flag = RecipeService.sharedRecipeService.deleteIngredient(ingredientObject!)
        XCTAssertTrue(flag, "RecipeService deleteIngredient should return true")
    }
    
    func testPhotosResultsControllerExists() {
        let resultsController = RecipeService.sharedRecipeService.photos()
        XCTAssertNotNil(resultsController, "RecipeService NSFetchedResultsController should not be nil")
    }
    
    func testPhotosPerformFetchExists() {
        let resultsController = RecipeService.sharedRecipeService.photos()
        XCTAssertNotNil(try! resultsController.performFetch(), "RecipeService perfromFetch() should not be nil")
    }
    
    func testPhotosResultsControllerSectionsExists() {
        let resultsController = RecipeService.sharedRecipeService.photos()
        try! resultsController.performFetch()
        
        if let sectionCount = resultsController.sections?.count {
            XCTAssertGreaterThan(sectionCount, 0, "Photos NSFetchedResultsController should contain more than 0 sections")
        } else {
            XCTFail("Photos NSFetchedResultsController doesn't contain more than 0 sections")
        }
    }
    
    func testAddPhotoFunction() {
        let image = UIImage(named: "MealPlan")
        let imageData = NSData(data: UIImagePNGRepresentation(image!)!)
        let imageObject = RecipeService.sharedRecipeService.addPhoto(imageData) as! Photo
        XCTAssertEqual(imageData, imageObject.imageData, "RecipeService addPhoto should return photo object")
    }
    
    func testPhotosResultsControllerSectionItemsExists() {
        let resultsController = RecipeService.sharedRecipeService.photos()
        try! resultsController.performFetch()
    
        if let sections = resultsController.sections {
            for section in sections {
                let itemCount = section.numberOfObjects
                XCTAssertGreaterThan(itemCount, 0, "Photos NSFetchedResultsController section(s) should contain more than 0 items")
            }
        }
    }
    
}
