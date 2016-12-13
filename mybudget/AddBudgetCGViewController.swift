//
//  AddBudgetCGViewController.swift
//  budget
//
//  Created by Azam Rahmat on 8/19/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import Firebase


class AddBudgetCGViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {
    
    var subcategory : SubCategoryTable?
    var update = false
    var addCategory = false
    var addSubCategory = false
    var category : CategoryTable?
    let images = (1...100).map{ i in
        "image" + String(i)
    }
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var selectedImage = ""
    
    @IBOutlet weak var name: UITextField!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.delegate = self
        if update && addCategory{
            name.text = category!.name!
            selectedImage = category!.icon!
        }
        else if update{
            name.text = subcategory!.name!
            selectedImage = subcategory!.icon!
        }
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func save(sender: AnyObject) {
        
        if name.text?.trim() != "" && selectedImage != ""
        {
            if addSubCategory
            {
                
                // if let budget = NSEntityDescription.insertNewObjectForEntityForName("SubCategoryTable", inManagedObjectContext: managedObjectContext!) as? SubCategoryTable
                if update{
                    if let subCtg = SubCategoryTable.subCategory(subcategory!.name!, categoryName : category!.name!,inManagedObjectContext: managedObjectContext!)
                    {
                        subCtg.name = name.text!.trim()
                        subCtg.icon = selectedImage
                    }
                }
                else
                {
                    let _ = SubCategoryTable.subcategory(name.text!, image: selectedImage, categoryName: category!.name!, inManagedObjectContext: managedObjectContext!)
                }
                
            }
            else if addCategory  {
                
                
                
                //if let budget = NSEntityDescription.insertNewObjectForEntityForName("CategoryTable", inManagedObjectContext: managedObjectContext!) as? CategoryTable
                
                if update {
                    if let ctg = CategoryTable.categoryByOnlyName(category!.name!, inManagedObjectContext: managedObjectContext!)
                    {
                        ctg.name = name.text
                        ctg.icon = selectedImage
                    }
                }
                else
                {
                    
                    let _ = CategoryTable.category(name.text!.trim(), image: selectedImage, inManagedObjectContext: managedObjectContext!)
                }
            }
            
            
            
            do{
                try self.managedObjectContext?.save()
               
               if !update
               {
                let info = (addCategory ? name.text!  : category!.name! + " > " + name.text!) + " \( selectedImage)"
                FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                    kFIRParameterItemID : "id-budget_category_subcategory" as NSObject,
                    
                    kFIRParameterItemName: "added " + (addCategory ? "category " : "subcategory ") + info as NSObject
                    ])
                }
                    /*
                    kFIRParameterContentType: update ? "update" : "new" as NSObject,
                    kFIRParameterValue : (addCategory ? name.text!  : category!.name! + " > " + name.text!) + " \( selectedImage)" as NSObject
                    ])*/
                
                navigationController?.popViewControllerAnimated(true)
                //receivedMessageFromServer()
                
            }
            catch{
                
            }
        }
       
    }
    @IBAction func cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        dismissKeyboard()
        
        selectedImage = images[indexPath.row]
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cvcel", forIndexPath: indexPath) as! CustomCollectionViewCell
        
        
        
        cell.img?.image = UIImage(named: images[indexPath.row])
        cell.img?.tintColor = Helper.colors[indexPath.row % 5]
        
        return cell
    }
    
}
