//
//  MealPlanViewController.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/6/15.
//
//

import UIKit
import CoreData

class MealPlanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecipeViewControllerDelegate {
    
    private var resultsController: NSFetchedResultsController?
    
    private var recipes = [NSManagedObject]()
    
    @IBAction func newPlan(sender: AnyObject) {
        do {
            try RecipeService.sharedRecipeService.clearRecipes()
        } catch let error {
            print("Error clearing data: \(error as NSError)")
            
            let alertController = UIAlertController(title: "Clear Failed", message: "Failed to clear existing recipe data", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        RecipeService.sharedRecipeService.searchRecipes { (error) -> Void in
            if let someError = error {
                let alertController = UIAlertController(title: "Request failed", message: someError.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.resultsController = RecipeService.sharedRecipeService.recipes()
                self.controllerDidChangeContent(self.resultsController!)
            }
        }
    }
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    // MARK: View Management
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsController = RecipeService.sharedRecipeService.recipes()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let count = resultsController?.sections?.count else {
            return 0
        }
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = resultsController?.sections?[section].numberOfObjects else {
            return 0
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("mealPlanCell", forIndexPath: indexPath) as! MealPlanCell
        
        if let recipe = resultsController?.objectAtIndexPath(indexPath) as? Recipe {
            cell.label.text = recipe.name
            cell.mealPlanImageView.image = UIImage(data: recipe.hostedSmallUrl!)

            recipes.append(recipe)
        }
        
        return cell
    }
    
    func recipeViewControllerDidFinish(recipeViewController: RecipeViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PresentRecipeSegue" {
            let navigationController = segue.destinationViewController as! UINavigationController
            navigationController.modalPresentationStyle = presentation
            navigationController.modalTransitionStyle = transition
            
            if let recipeViewController = navigationController.topViewController as? RecipeViewController {
                let indexPath = tableView.indexPathForSelectedRow!
                recipeViewController.delegate = self
                
                let recipeObject = resultsController?.objectAtIndexPath(indexPath) as! Recipe
                recipeViewController.recipe = recipeObject
            }
        }
    }
    
    private var presentation = UIModalPresentationStyle.FullScreen
    private var transition = UIModalTransitionStyle.CoverVertical
    
}