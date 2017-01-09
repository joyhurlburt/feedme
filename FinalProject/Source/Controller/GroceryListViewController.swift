//
//  GroceryListViewController.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/6/15.
//
//

import UIKit
import CoreData

class GroceryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var resultsController: NSFetchedResultsController?
    
    private var ingredients = [NSManagedObject]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func addGroceryItem(sender: AnyObject) {
        var itemTextField: UITextField?
        
        let alertController = UIAlertController(title: "Grocery List", message: "Add a grocery list item", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            itemTextField = textField
            itemTextField?.placeholder = "Enter your grocery item"
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print("Cancel Button Pressed")
        }
        
        let save = UIAlertAction(title: "Save", style: .Default, handler: { (action) -> Void in
            if let item = itemTextField?.text {
                let savedItem = RecipeService.sharedRecipeService.addIngredient(item) as! Ingredient
                self.ingredients.append(savedItem)
            }
            self.resultsController = RecipeService.sharedRecipeService.ingredients()
            self.tableView.reloadData()
        })
        
        alertController.addAction(save)
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem()
        resultsController = RecipeService.sharedRecipeService.ingredients()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("groceryCell", forIndexPath: indexPath) as! GroceryCell
        
        if let ingredient = resultsController?.objectAtIndexPath(indexPath) as? Ingredient {
            cell.label.text = ingredient.name
            ingredients.append(ingredient)
            
            if ingredient.checked == false {
                cell.accessoryType = .None
            } else if ingredient.checked == true {
                cell.accessoryType = .Checkmark
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GroceryCell
        
        if let ingredient = resultsController?.objectAtIndexPath(indexPath) as? Ingredient {
            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                RecipeService.sharedRecipeService.updateIngredient(ingredient.name!, checked: false)
            } else {
                cell.accessoryType = .Checkmark
                RecipeService.sharedRecipeService.updateIngredient(ingredient.name!, checked: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            RecipeService.sharedRecipeService.deleteIngredient(ingredients[indexPath.row])
            ingredients.removeAtIndex(indexPath.row)
            resultsController = RecipeService.sharedRecipeService.ingredients()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        tableView.adjustInsetsForWillShowKeyboardNotification(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        tableView.adjustInsetsForWillHideKeyboardNotification(notification)
    }

    
}