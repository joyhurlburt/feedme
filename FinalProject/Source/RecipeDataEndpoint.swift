//
//  RecipeDataEndpoint.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/20/15.
//
//

import CoreData
import CoreDataService
import Foundation

class RecipeDataEndpoint {
    
    private var diets = [Diet]()
    
    private static let app_id = "8c81c4a5"
    private static let app_key = "33a9d086b5ba586b6dc2ea323c58e2cd"
    
    private static let APIEndpointBaseUrl = "https://api.yummly.com/v1/api"
    private static let GetRecipeBaseUrl = "\(APIEndpointBaseUrl)/recipe"
    private static let SearchRecipesBaseUrl = "\(APIEndpointBaseUrl)/recipes"
    private static let AuthenticationUrl = "_app_id=\(app_id)&_app_key=\(app_key)"
    
    func searchRecipesCall() -> String {
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        let fetchRequest = NSFetchRequest(namedEntity: Diet.self)
        do {
            let fetchedEntities = try context.executeFetchRequest(fetchRequest) as! [Diet]
            for entity in fetchedEntities {
                if entity.selected == true {
                    diets.append(entity)
                }
            }
        } catch {
            print("Error: executeFetchRequest() failed")
        }
        
        let start = Int(arc4random_uniform(1000))
        
        var temp = "\(RecipeDataEndpoint.SearchRecipesBaseUrl)?\(RecipeDataEndpoint.AuthenticationUrl)&maxResult=5&start=\(start)&requirePictures=true&allowedCourse[]=course^course-Main Dishes&allowedCourse[]=course^course-Side Dishes&allowedCourse[]=course^course-Salads&allowedCourse[]=course^course-Soups"
        
        for diet in diets {
            if diet.name == "Pescetarian" {
                temp = temp + "&allowedDiet[]=390^Pescetarian"
            } else if diet.name == "Vegetarian" {
                temp = temp + "&allowedDiet[]=387^Lacto-ovo vegetarian"
            } else if diet.name == "Vegan" {
                temp = temp + "&allowedDiet[]=386^Vegan"
            } else if diet.name == "Gluten-Free" {
                temp = temp + "&allowedAllergy[]=393^Gluten-Free"
            } else if diet.name == "Dairy-Free" {
                temp = temp + "&allowedAllergy[]=396^Dairy-Free"
            } else if diet.name == "Nut-Free" {
                temp = temp + "&allowedAllergy[]=395^Tree Nut-Free"
            } else if diet.name == "Peanut-Free" {
                temp = temp + "&allowedAllergy[]=394^Peanut-Free"
            }
        }
        
        let urlString = temp
        return urlString
    }
    
    func getRecipeCall(recipe: Recipe) -> String {
        let recipe_id = recipe.id
        let temp = "\(RecipeDataEndpoint.GetRecipeBaseUrl)/\(recipe_id!)?\(RecipeDataEndpoint.AuthenticationUrl)"
        
        let urlString = temp
        return urlString
    }
    
    func searchRecipes(completionHandler: (error: NSError?) -> Void) {
        
        let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        let urlString = searchRecipesCall().stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let url = NSURL(string: urlString!)!
        let urlRequest = NSMutableURLRequest(URL: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, urlResponse: NSURLResponse?, error: NSError?) -> Void in
            if let someData = data, let someResponse = urlResponse as? NSHTTPURLResponse where someResponse.statusCode == 200 {
                do {
                    let jsonValues = try NSJSONSerialization.JSONObjectWithData(someData, options: [])
                    self.processSearchRecipeContent(jsonValues, completionHandler: completionHandler)
                }
                catch let error {
                    self.finishWithError(error as NSError, completionHandler: completionHandler)
                }
            }
            else {
                if let someError = error {
                    self.finishWithError(someError, completionHandler: completionHandler)
                }
                else {
                    self.finishWithRequestErrorWithMessage("The request failed", completionHandler: completionHandler)
                }
            }
        })
        
        dataTask.resume()
    }
    
    func getRecipe(recipe: Recipe, completionHandler: (error: NSError?) -> Void) {
        
        let urlSession = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        let urlString = getRecipeCall(recipe).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let url = NSURL(string: urlString!)!
        let urlRequest = NSMutableURLRequest(URL: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        let dataTask = urlSession.dataTaskWithRequest(urlRequest, completionHandler: { (data: NSData?, urlResponse: NSURLResponse?, error: NSError?) -> Void in
            if let someData = data, let someResponse = urlResponse as? NSHTTPURLResponse where someResponse.statusCode == 200 {
                do {
                    let jsonValues = try NSJSONSerialization.JSONObjectWithData(someData, options: [])
                    self.processGetRecipeContent(jsonValues, completionHandler: completionHandler)
                }
                catch let error {
                    self.finishWithError(error as NSError, completionHandler: completionHandler)
                }
            }
            else {
                if let someError = error {
                    self.finishWithError(someError, completionHandler: completionHandler)
                }
                else {
                    self.finishWithRequestErrorWithMessage("The request failed", completionHandler: completionHandler)
                }
            }
        })
        
        dataTask.resume()
    }
    
    private func processSearchRecipeContent(jsonValues: AnyObject, completionHandler: (error: NSError?) -> Void) {
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.parentContext = context
        
        backgroundContext.performBlock({ () -> Void in
            if let allRecipeValues = jsonValues as? Dictionary<String, AnyObject> {
                do {
                    let recipeMatches = allRecipeValues["matches"] as! Array<Dictionary<String, AnyObject>>
                    for match in recipeMatches {
                        try self.createOrUpdateSearchRecipesWithValues(match, inContext: backgroundContext)
                    }
                    
                    self.saveBackgroundContext(backgroundContext, andFinishWithCompletionHandler: completionHandler)
                }
                catch let error {
                    self.finishWithError(error as NSError, completionHandler: completionHandler)
                }
            }
            else {
                self.finishWithProcessingErrorWithMessage("Unexpected root json types received.", completionHandler: completionHandler)
            }
        })
    }
    
    private func processGetRecipeContent(jsonValues: AnyObject, completionHandler: (error: NSError?) -> Void) {
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        let backgroundContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        backgroundContext.parentContext = context
        
        backgroundContext.performBlock({ () -> Void in
            if let allRecipeValues = jsonValues as? Dictionary<String, AnyObject> {
                do {
                    try self.createOrUpdateGetRecipeWithValues(allRecipeValues, inContext: backgroundContext)
                    
                    self.saveBackgroundContext(backgroundContext, andFinishWithCompletionHandler: completionHandler)
                }
                catch let error {
                    self.finishWithError(error as NSError, completionHandler: completionHandler)
                }
            }
            else {
                self.finishWithProcessingErrorWithMessage("Unexpected root json types received.", completionHandler: completionHandler)
            }
        })
    }
    
    private func createOrUpdateSearchRecipesWithValues(match: Dictionary<String, AnyObject>, inContext context: NSManagedObjectContext) throws {
        if let name = match["recipeName"] as? String {
            let recipe: Recipe
            
            if let existingRecipe = RecipeService.sharedRecipeService.lookupRecipeWithName(name, inContext: context) {
                recipe = existingRecipe
                print(recipe.name)
            } else {
                recipe = NSEntityDescription.insertNewObjectForNamedEntity(Recipe.self, inManagedObjectContext: context)
                
                let smallImageUrls = match["smallImageUrls"] as! Array<String>
                let smallImage = smallImageUrls[0]
                
                let url = NSURL(string: smallImage)
                let data = NSData(contentsOfURL: url!)
                let image = UIImage(data: data!)
                
                let hostedSmallUrl = NSData(data: UIImagePNGRepresentation(image!)!)
                
                let id = match["id"] as! String
                
                let totalTime = "totalTime"
                let yield = "yield"
                let sourceRecipeUrl = "sourceRecipeUrl"
                
                let largeImage = UIImage(named: "MealPlan")
                let hostedLargeUrl = NSData(data: UIImagePNGRepresentation(largeImage!)!)
                
                recipe.name = name
                recipe.hostedSmallUrl = hostedSmallUrl
                recipe.id = id
                recipe.totalTime = totalTime
                recipe.yield = yield
                recipe.sourceRecipeUrl = sourceRecipeUrl
                recipe.hostedLargeUrl = hostedLargeUrl
            }
            
        } else {
            throw processingErrorWithMessage("Incorrect type or nil value for recipe name")
        }
        
    }
    
    private func createOrUpdateGetRecipeWithValues(allRecipeValues: Dictionary<String, AnyObject>, inContext context: NSManagedObjectContext) throws {
        
        if let name = allRecipeValues["name"] as? String {
            let totalTime = allRecipeValues["totalTime"] as! String
            
            let numberOfServings = allRecipeValues["numberOfServings"] as! Int
            let yield = String(numberOfServings)
            
            let source = allRecipeValues["source"] as! Dictionary<String, String>
            let sourceRecipeUrl = source["sourceRecipeUrl"]!
            
            let images = allRecipeValues["images"] as! Array<Dictionary<String, AnyObject>>
            let largeImage = images[0]["hostedLargeUrl"] as! String
            
            let url = NSURL(string: largeImage)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            
            let hostedLargeUrl = NSData(data: UIImagePNGRepresentation(image!)!)
            
            RecipeService.sharedRecipeService.updateRecipe(name, totalTime: totalTime, yield: yield, sourceRecipeUrl: sourceRecipeUrl, hostedLargeUrl: hostedLargeUrl)
            
        } else {
            throw processingErrorWithMessage("Incorrect type or nil value for recipe name")
        }
        
    }
    
    private func saveBackgroundContext(backgroundContext: NSManagedObjectContext, andFinishWithCompletionHandler completionHandler: (error: NSError?) -> Void) {
        do {
            try backgroundContext.save()
            
            let mainContext = CoreDataService.sharedCoreDataService.mainQueueContext
            mainContext.performBlock({ () -> Void in
                do {
                    try mainContext.save()
                    
                    CoreDataService.sharedCoreDataService.saveRootContext({ () -> Void in
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            completionHandler(error: nil)
                        })
                    })
                }
                catch let error {
                    self.finishWithError(error as NSError, completionHandler: completionHandler)
                }
            })
        }
        catch let error {
            self.finishWithError(error as NSError, completionHandler: completionHandler)
        }
    }
    
    private func finishWithRequestErrorWithMessage(message: String, completionHandler: (error: NSError) -> Void) {
        let userInfo = [NSLocalizedDescriptionKey : message]
        let error = NSError(domain: RecipeDataEndpoint.ErrorDomain, code: RecipeDataEndpoint.ErrorCode.RequestError.rawValue, userInfo: userInfo)
        
        finishWithError(error, completionHandler: completionHandler)
    }
    
    private func finishWithProcessingErrorWithMessage(message: String, completionHandler: (error: NSError) -> Void) {
        let error = processingErrorWithMessage(message)
        
        finishWithError(error, completionHandler: completionHandler)
    }
    
    private func processingErrorWithMessage(message: String) -> NSError {
        let userInfo = [NSLocalizedDescriptionKey : message]
        return NSError(domain: RecipeDataEndpoint.ErrorDomain, code: RecipeDataEndpoint.ErrorCode.ProcessingError.rawValue, userInfo: userInfo)
    }
    
    private func finishWithError(error: NSError, completionHandler: (error: NSError) -> Void) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            completionHandler(error: error)
        })
    }
    
    static let ErrorDomain = "com.cis410.FinalProject.RecipeDataEndpoint"
    enum ErrorCode: Int {
        case RequestError = 1
        case ProcessingError
    }
    
}