//
//  DietViewController.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/5/15.
//
//

import UIKit
import CoreData

class DietViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var resultsController: NSFetchedResultsController?
    
    private var diets = [NSManagedObject]()
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func switchToggled(sender: UISwitch) {
        let diet = diets[sender.tag]
        let dietObject = diet as! Diet
        if sender.on {
            RecipeService.sharedRecipeService.updateDiet(dietObject.name!, selected: true)
        } else {
            RecipeService.sharedRecipeService.updateDiet(dietObject.name!, selected: false)
        }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsController = RecipeService.sharedRecipeService.diets()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("dietCell", forIndexPath: indexPath) as! DietCell
        
        if let diet = resultsController?.objectAtIndexPath(indexPath) as? Diet {
            cell.label.text = diet.name
            cell.dietSwitch.tag = indexPath.row
            diets.append(diet)
            
            if diet.selected == true {
                cell.dietSwitch.setOn(true, animated: true)
                cell.dietImageView.image = UIImage(named: "\(diet.name!)-Filled")
            } else {
                cell.dietSwitch.setOn(false, animated: true)
                cell.dietImageView.image = UIImage(named: diet.name!)
            }
        }
        
        return cell
    }
    
}