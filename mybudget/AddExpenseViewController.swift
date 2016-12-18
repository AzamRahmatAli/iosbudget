//
//  AddExpenseViewController.swift
//  budget
//
//  Created by Azam Rahmat on 7/29/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import StoreKit
import Firebase

class AddExpenseViewController: UIViewController, UITextFieldDelegate,UIActionSheetDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UIScrollViewDelegate,  SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    
    @IBOutlet weak var category: UITextField!
    
    @IBOutlet weak var subCategory: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    
    @IBOutlet weak var missing: UILabel!
    
    @IBOutlet weak var expnseDate: UITextField!
    
    @IBOutlet weak var reciept: UIImageView!
    @IBOutlet weak var note: UITextField!
    
    @IBOutlet weak var payFrom: UITextField!
    @IBOutlet weak var deleteExpenseButton: UIButton!
    var dateValue = NSDate()
    var updateExpens = false
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var expenseData : ExpenseTable?
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var imagePicked = false
    var scrollV : UIScrollView!
    var imageView : UIImageView!
    var product_id: String?
    let defaults = NSUserDefaults.standardUserDefaults()
    
    // Unlock Content. This is button action which will initialize purchase
    
    
    
    //Delegate Methods for IAP
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        let count : Int = response.products.count
        if (count > 0) {
            _ = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                //print(validProduct.localizedTitle)
                //print(validProduct.localizedDescription)
                //print(validProduct.price)
                buyProduct(validProduct);
            } else {
                //print(validProduct.productIdentifier)
            }
        } else {
            //print("nothing")
        }
    }
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        //print("Error Fetching product information");
        Helper.alertUser(self, title: "In-App Purchase", message: "Something went wrong. Please try later.")
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])    {
        //print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    //print("Product Purchased");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    defaults.setBool(true , forKey: "alreadyPurchased")
                    
                    FIRAnalytics.setUserPropertyString("Purchased", forName: "app_purchased")
                    
                    FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                        kFIRParameterItemID : "id-app_purchased" as NSObject,
                        kFIRParameterContentType: "purchased" as NSObject,
                        
                        ])
                    break;
                    
                case .Failed:
                    //print("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    FIRAnalytics.setUserPropertyString("Failed", forName: "app_purchased")
                    
                    FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                        kFIRParameterItemID : "id-app_purchased" as NSObject,
                        kFIRParameterContentType : "failed" as NSObject
                        ])
                    
                    break;
                    
                    
                    
                case .Restored:
                    //print("Already Purchased");
                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                    
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    defaults.setBool(true , forKey: "alreadyPurchased")
                    
                    FIRAnalytics.setUserPropertyString("restored", forName: "app_purchased")
                    
                    FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                        kFIRParameterItemID : "id-app_purchased" as NSObject,
                        kFIRParameterContentType : "restored" as NSObject
                        ])
                    
                    
                default:
                    break;
                }
            }
        }
        
    }
    
    
    // Helper Method
    func buyProduct(product: SKProduct){
        //print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Helper.performUIUpdatesOnMain{
            self.viewLoad()
        }
        
    }
    
    func viewLoad()
    {
        
        product_id = "com.bltechapps.expensemanager.iap"
        
        
        
        //Check if product is purchased
        
        
        
        
        category.delegate = self
        subCategory.delegate = self
        expnseDate.delegate = self
        amount.delegate = self
        payFrom.delegate = self
        imagePicker.delegate = self
        note.delegate = self
        
        
        
        if updateExpens
        {
            
            category.text = expenseData!.subCategory?.category!.name
            amount.text = expenseData!.amount
            subCategory.text =  expenseData!.subCategory?.name
            
            dateValue = expenseData!.createdAt!
            note.text = expenseData!.note
            if let account = expenseData!.account
            {
                payFrom.text = account.name
                
            }
            if let image = expenseData?.reciept
            {
                
                reciept.image = UIImage(data: image)
                
                
            }
            self.title = "Update Expense"
        }
        else
        {
            deleteExpenseButton.hidden = true
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddExpenseViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        guard (defaults.boolForKey("alreadyPurchased"))
            else {
                if Helper.managedObjectContext!.countForFetchRequest( NSFetchRequest(entityName: "ExpenseTable") , error: nil) >= 9 {
                    if (SKPaymentQueue.canMakePayments()) {
                        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
                        
                    }
                    
                    //print("false")
                    FIRAnalytics.setUserPropertyString("not", forName: "app_purchased")
                    FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                        kFIRParameterItemID : "id-app_purchased" as NSObject,
                        kFIRParameterContentType: "app_purchased not" as NSObject
                        ])
                }
                
                return
                
        }
        
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        // Constants.Picker.chooseSubCategory = true
        if textField == expnseDate
        {
            self.performSegueWithIdentifier("pickDate", sender: nil)
        }else if textField  == amount
        {
            if amount.text == "0"
            {
                amount.text = ""
                
            }
            return true
        }else if textField  == payFrom
        {
            Helper.pickAccount = true
            self.performSegueWithIdentifier("pickAccount", sender: nil)
        }
        else if textField  == note
        {
            return true
        }
            
        else {
            Helper.pickCategory = true
            self.performSegueWithIdentifier("pickCategory", sender: nil)
        }
        return false
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField  == amount
        {
            let aSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
            let compSepByCharInSet = string.componentsSeparatedByCharactersInSet(aSet)
            let numberFiltered = compSepByCharInSet.joinWithSeparator("")
            let countdots = textField.text!.componentsSeparatedByString(".").count - 1
            
            if countdots > 0 && string == "."
            {
                return false
            }
            return string == numberFiltered
        }
        else{
            return true
        }
    }
    
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
    @IBAction func deleteExpense(sender: UIButton) {
        
        managedObjectContext!.deleteObject(expenseData!)
        Helper.saveChanges(managedObjectContext!, viewController: self)
        
    }
    
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    func getImageFromGallery() {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        imagePicked = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
    func getImageFromCamera() {
        
        imagePicker.sourceType = .Camera
        imagePicked = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        reciept.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    @IBAction func longPress(sender: UILongPressGestureRecognizer) {
        
        //Create the AlertController and add Its action like button in Actionsheet
        if let _ = expenseData?.reciept
        {
            
            
            
            
            
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "Update receipt image from", preferredStyle: .ActionSheet)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .Default)
            { action -> Void in
                self.getImageFromCamera()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
            { action -> Void in
                self.getImageFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            
        }
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    func imageTapped(img: AnyObject)
    {
        scrollV.hidden = true
    }
    
    
    @IBAction func addReciept(sender: UITapGestureRecognizer) {
        //Create the AlertController and add Its action like button in Actionsheet
        if let image = expenseData?.reciept
        {
            
            zoomReciept(image)
        }
        else{
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "Attach receipt image from", preferredStyle: .ActionSheet)
            
            
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Camera", style: .Default)
            { action -> Void in
                self.getImageFromCamera()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Photo Library", style: .Default)
            { action -> Void in
                self.getImageFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
        }
    }
    
    
    
    
    @IBAction func Cancel(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func addExpense(sender: AnyObject) {
        
        
        if updateExpens
        {
            
            
            if let entity =  managedObjectContext!.objectWithID(expenseData!.objectID)  as? ExpenseTable
            {
                
                entity.amount = (amount.text != "") ? amount.text : "0"
                
                if let account = Helper.pickedAccountData
                {
                    entity.account = account
                    Helper.pickedAccountData = nil
                }
                
                if let category = Helper.pickedSubCaregory
                {
                    entity.subCategory = category
                    Helper.pickedSubCaregory = nil
                }
                
                if imagePicked
                {
                    let image = self.ResizeImage(reciept.image!, targetSize: CGSizeMake(500.0, 500.0))
                    entity.reciept = UIImageJPEGRepresentation(image, 1.0)//back by UIImage(data: imageData)
                    imagePicked = false
                }
                
                
                entity.createdAt = dateValue
                
                entity.note = note.text?.trim()
                
                do {
                    try self.managedObjectContext!.save()
                    navigationController?.popViewControllerAnimated(true)
                } catch let nsError as NSError{
                    FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
                    //print("error")
                }
            }
            
        }
            
        else if  defaults.boolForKey("alreadyPurchased")  || Helper.managedObjectContext!.countForFetchRequest( NSFetchRequest(entityName: "ExpenseTable") , error: nil) < 10
        {
            if let entity = NSEntityDescription.insertNewObjectForEntityForName("ExpenseTable", inManagedObjectContext: managedObjectContext!) as? ExpenseTable
                
                
            {
                
                if category.text?.trim() != ""
                {
                    
                    /*if amount.text != ""
                     {
                     }else{
                     missing.text = "Enter Amount"
                     }*/
                    entity.subCategory = Helper.pickedSubCaregory
                    entity.amount =  (amount.text != "") ? amount.text : "0"
                    
                    entity.createdAt = dateValue
                    
                    if imagePicked
                    {
                        let image = self.ResizeImage(reciept.image!, targetSize: CGSizeMake(500.0, 500.0))
                        entity.reciept = UIImageJPEGRepresentation(image, 1.0)//back by UIImage(data: imageData)
                        imagePicked = false
                    }
                    entity.note = note.text?.trim()
                    //var accountName = ""
                    if let account = Helper.pickedAccountData
                    {
                        entity.account = account
                        //accountName = account.name!
                        Helper.pickedAccountData = nil
                    }
                    
                    
                    //print(entity)
                    do{
                        try self.managedObjectContext?.save()
                        
                        FIRAnalytics.logEventWithName(kFIREventSelectContent, parameters: [
                            kFIRParameterItemID : "add_expense" as NSObject,
                            kFIRParameterContentType : "added_expense" as NSObject
                            ])
                        
                        /*
                         kFIRParameterValue : amount.text! as NSObject,
                         kFIRParameterItemCategory: Helper.pickedSubCaregory!.name! + " > "  + Helper.pickedSubCaregory!.category!.name!  + " account "  + accountName as NSObject,
                         
                         ])*/
                        navigationController?.popViewControllerAnimated(true)
                        //receivedMessageFromServer()
                        
                    }
                    catch let nsError as NSError{
                        FIRAnalytics.setUserPropertyString(nsError.localizedDescription, forName: "catch_error_description")
                        
                    }
                    
                }
                else{
                    missing.text = "Select category"
                }
                
                
            }
        }else{
            let alertController = UIAlertController(title: "Thank You for using \(StringFor.name["appName"]!)", message:  "You have reached the limit of adding 10 expenses in this free version. Purchase to remove this limit forever", preferredStyle: UIAlertControllerStyle.Alert)
            
            
            let yesAction = UIAlertAction(title: "Purchase", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                FIRAnalytics.setUserPropertyString("Next", forName: "app_purchased")
                //print("About to fetch the products")
                
                // We check that we are allow to make the purchase.
                
                
                if (SKPaymentQueue.canMakePayments())
                {
                    let productID: Set<String> = [self.product_id!];
                    let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID  );
                    productsRequest.delegate = self;
                    productsRequest.start();
                    //print("Fetching Products");
                }else{
                    //print("can't make purchases");
                    Helper.alertUser(self, title: "In-App Purchase", message: "Can't make purchase. Please try later.")
                }
                
            }
            let noAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
                FIRAnalytics.setUserPropertyString("Cancel", forName: "app_purchased")
            }
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if Helper.categoryPicked
        {
            
            
            category.text = Helper.pickedSubCaregory?.category!.name
            
            subCategory.text = Helper.pickedSubCaregory?.name
            
            
            
            Helper.categoryPicked = false
            
        }
        else if Helper.accountPicked
        {
            
            
            Helper.pickAccount = false
            Helper.accountPicked = false
            if let account = Helper.pickedAccountData
            {
                payFrom.text = account.name
                
            }
        }
            
            
        else if let date  = Helper.datePic
        {
            dateValue = date
            Helper.datePic = nil
            
            
        }
        else if !Helper.accountPicked
        {
            
            
            Helper.pickCategory = false
            
            
        }
        
        
        expnseDate.text = Helper.getFormattedDate(dateValue)
        
        
    }
    
    func receivedMessageFromServer() {
        NSNotificationCenter.defaultCenter().postNotificationName("ReceivedData", object: nil)
    }
    
    
    
    func zoomReciept(image : NSData)
    {
        
        scrollV=UIScrollView()
        scrollV.hidden = false
        scrollV.frame = CGRectMake(0, self.navigationController!.navigationBar.frame.size.height, self.view.frame.width, self.view.frame.height)
        scrollV.minimumZoomScale=1
        scrollV.maximumZoomScale=3
        scrollV.bounces=false
        scrollV.delegate=self;
        self.view.addSubview(scrollV)
        
        imageView=UIImageView()
        imageView.image = UIImage(data: image)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(AddExpenseViewController.imageTapped(_:)))
        
        scrollV.addGestureRecognizer(tapGestureRecognizer)
        imageView.frame = CGRectMake(0, 0, scrollV.frame.width, scrollV.frame.height)
        imageView.backgroundColor = .blackColor()
        imageView.contentMode = .ScaleAspectFit
        scrollV.addSubview(imageView)
        
    }
    
}
