//
//  PhotosViewController.swift
//  FinalProject
//
//  Created by Joy Hurburt on 11/6/15.
//
//

import UIKit
import CoreData

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private var resultsController: NSFetchedResultsController?
    
    private var images = [NSManagedObject]()
    
    private let imagePicker = UIImagePickerController()
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image: UIImage
        if let newImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            image = newImage
        } else if let newImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image = newImage
        } else {
            return
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        let imageData = NSData(data: UIImagePNGRepresentation(image)!)
        let savedPhoto = RecipeService.sharedRecipeService.addPhoto(imageData)
        
        images.insert(savedPhoto, atIndex: 0)
        resultsController = RecipeService.sharedRecipeService.photos()
        collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        resultsController = RecipeService.sharedRecipeService.photos()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let count = resultsController?.sections?.count else {
            return 0
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = resultsController?.sections?[section].numberOfObjects else {
            return 0
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        
        if let photo = resultsController?.objectAtIndexPath(indexPath) as? Photo {
            cell.imageView.image = UIImage(data: photo.imageData!)
            images.insert(photo, atIndex: 0)
        }
        
        return cell
    }
}