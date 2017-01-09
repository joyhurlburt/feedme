//
//  RecipeViewController.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/6/15.
//
//

import UIKit
import CoreData

class RecipeViewController: UIViewController {
    
    weak var delegate: RecipeViewControllerDelegate?
    
    var recipe: Recipe!
    
    private var resultsController: NSFetchedResultsController?
    
    private var ingredientLines = [NSManagedObject]()
    
    private var sourceRecipeUrl: String = ""
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var yield: UILabel!
    
    @IBOutlet weak var totalTime: UILabel!
    
    @IBAction private func done(sender: AnyObject) {
        delegate?.recipeViewControllerDidFinish(self)
    }
    
    @IBAction func goToRecipe(sender: AnyObject) {
        let targetUrl = NSURL(string: sourceRecipeUrl)
        let application = UIApplication.sharedApplication()
        
        application.openURL(targetUrl!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecipeService.sharedRecipeService.getRecipe(self.recipe, completionHandler: { (error) -> Void in
            if let someError = error {
                let alertController = UIAlertController(title: "Request failed", message: someError.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.initView()
            }
        })
        
    }
    
    func initView() {
        name.text = recipe.name
        yield.text = "Yield: \(recipe.yield!)"
        totalTime.text = "Time: \(recipe.totalTime!)"
        sourceRecipeUrl = recipe.sourceRecipeUrl!
        imageView.image = UIImage(data: recipe.hostedLargeUrl!)
    }
    
}