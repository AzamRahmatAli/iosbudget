//
//  AppDelegate.swift
//  budget
//
//  Created by Azam Rahmat on 7/21/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData
import StoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver, SKProductsRequestDelegate {

    var window: UIWindow?
    var product_id: String?
    let defaults = NSUserDefaults.standardUserDefaults()
    var purchased = false
    //
    //Delegate Methods for IAP
    
    func productsRequest (request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        let count : Int = response.products.count
        print(response, response.products)
        if (count > 0) {
            _ = response.products
            let validProduct: SKProduct = response.products[0] as SKProduct
            if (validProduct.productIdentifier == self.product_id) {
                print(validProduct.localizedTitle)
                print(validProduct.localizedDescription)
                print(validProduct.price)
                buyProduct(validProduct);
            } else {
                print(validProduct.productIdentifier)
            }
        } else {
            print("nothing")
        }
    }
    
    
    func request(request: SKRequest, didFailWithError error: NSError) {
        print("Error Fetching product information");
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction])    {
        print("Received Payment Transaction Response from Apple");
        
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
                switch trans.transactionState {
                case .Purchased:
                    print("Product Purchased");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    defaults.setBool(true , forKey: "purchased")
                    purchased = true
                    // overlayView.hidden = true
                    break;
                case .Failed:
                    print("Purchased Failed");
                    SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break;
                    
                    
                    
                case .Restored:
                    print("Already Purchased");
                    SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
                    
                    
                default:
                    break;
                }
            }
        }
        
    }
    func buyProduct(product: SKProduct){
        print("Sending the Payment Request to Apple");
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment);
        
    }
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /*product_id = "com.brainload.mybudget.iap"
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        if (SKPaymentQueue.canMakePayments())
        {
            let productID: Set<String> = [self.product_id!];
            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID  );
            productsRequest.delegate = self;
            productsRequest.start();
            print("Fetching Products");
        }else{
            print("can't make purchases");
        }*/
        
        let request = NSFetchRequest(entityName: "Other")
        Helper.formatter.numberStyle = .CurrencyStyle
        
        
        
        if managedObjectContext.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                
                if let isLockOn = queryResult.lockOn
                {
                    Helper.passwordProtectionOn = Bool(isLockOn)
                    Helper.password = queryResult.password!
                    
                }
                if let currencyCode = queryResult.currencyCode
                {
                Helper.formatter.currencyCode = currencyCode
                Helper.formatter.currencySymbol = queryResult.currencySymbol
                }
                if let date = queryResult.backupTime
                {
                    Helper.lastBackupTime = date
                }
                if let frequency = queryResult.backupFrequency
                {
                    Helper.backupFrequency = autoBackupFrequency(rawValue: frequency )!
                }
            }
            catch let error {
                print("error : ", error)
            }
            
            
            
        }
        
        
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce"))
        {
            // app already launched
        }
        else
        {
            // This is the first launch ever
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
            //let Category = ["Utilities", "Food"]
          
            BasicData.addBasicData()
           
            
            
        }
        
        //iCloudAccountIsSignedIn()
        CloudDataManager.autoBackup()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        //var initialViewController = storyboard.instantiateViewControllerWithIdentifier("entryPoint")
        if Helper.passwordProtectionOn
        {
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("lock")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        }
    
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
            
        
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            
               // topController.view.hidden = true
            
            // topController should now be your topmost view controller
        }
        
            /*let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("lock")
            guard let rvc = self.window?.rootViewController else {
                return
            }
            if let vc = getCurrentViewController(rvc) {
                // do your stuff here
                
                vc.presentViewController(nextViewController, animated:true, completion:nil)
            }
            */
            /*print(self.window!.rootViewController!)
             self.window!.rootViewController!.presentViewController(nextViewController, animated:true, completion:nil)*/
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        if var topController = UIApplication.sharedApplication().keyWindow?.rootViewController {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("lock")
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if !Helper.lockActivated && Helper.passwordProtectionOn
            {
                topController.presentViewController(nextViewController, animated:true, completion:nil)
                
            }
            // topController should now be your topmost view controller
        }

    }
    func getCurrentViewController(vc: UIViewController) -> UIViewController? {
        if let pvc = vc.presentedViewController {
            return getCurrentViewController(pvc)
        }
        else if let svc = vc as? UISplitViewController where svc.viewControllers.count > 0 {
            return getCurrentViewController(svc.viewControllers.last!)
        }
        else if let nc = vc as? UINavigationController where nc.viewControllers.count > 0 {
            return getCurrentViewController(nc.topViewController!)
        }
        else if let tbc = vc as? UITabBarController {
            if let svc = tbc.selectedViewController {
                return getCurrentViewController(svc)
            }
        }
        return vc
    }
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.brainloadtech.budget" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("budget", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        
        
        let storeURL = documentsDirectory!.URLByAppendingPathComponent("CoreData.sqlite")
        
        NSLog("storeURL:\(storeURL)")
        
        let storeOptions = [NSPersistentStoreUbiquitousContentNameKey:"AppStore"]
        
      
        

        
        
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    func iCloudAccountIsSignedIn() -> Bool {
        print("Running \(self.self) '\(NSStringFromSelector(#function))'")
        let token = NSFileManager.defaultManager().ubiquityIdentityToken
        if (token != nil) {
            print("----iCloud is Logged In with token '\(token)' ----")
            return true
        }
        print("---- iCloud is NOT Logged In ----")
        print("Check these: Is iCloud Documents and Data enabled??? (Mac, IOS Device)--- iCloud Capability -App Target, ---- Code Sign Entitlements Error??")
        return false
    }
    // MARK: - Core Data stack
    // All the following code is in my appDelgate Core data stack
    
    func observeCloudActions(persistentStoreCoordinator psc:      NSPersistentStoreCoordinator?) {
        // Register iCloud notifications observers for;
        
        //Stores Will change
        //Stores Did Change
        //persistentStoreDidImportUbiquitousContentChanges
        //mergeChanges
        
    }
    
    //Functions for notifications
    
    func mergeChanges(notification: NSNotification) {
        NSLog("mergeChanges notif:\(notification)")
        
            managedObjectContext.performBlock {
                self.managedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
                self.postRefetchDatabaseNotification()
            }
        
    }
    
    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
        self.mergeChanges(notification);
    }
    
    func storesWillChange(notification: NSNotification) {
        NSLog("storesWillChange notif:\(notification)");
       
            managedObjectContext.performBlockAndWait {
                
               
                self.managedObjectContext.reset();
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("storeWillChange", object: nil)
            
        
    }
    
    func storesDidChange(notification: NSNotification) {
        NSLog("storesDidChange posting notif");
        self.postRefetchDatabaseNotification();
        //Sends notification to view controllers to reload data      NSNotificationCenter.defaultCenter().postNotificationName("storeDidChange", object: nil)
        
    }
    
    func postRefetchDatabaseNotification() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("storeDidChange", object: nil)
            
        })
    }
    
    
    // Core data stack
    
    /*lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "hyouuu.pendo" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()*/
    
    /*lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("AppName", withExtension: "momd")!
        NSLog("modelURL:\(modelURL)")
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()*/
    
    /*lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last 
        
        
        let storeURL = documentsDirectory!.URLByAppendingPathComponent("CoreData.sqlite")
        
        NSLog("storeURL:\(storeURL)")
        
        let storeOptions = [NSPersistentStoreUbiquitousContentNameKey:"AppStore"]
        
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do {
         
       try coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "Pendo_Error_Domain", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("AddPersistentStore error \(error), \(error!.userInfo)")
        
        }
            catch
            {
                
        }
        
        self.observeCloudActions(persistentStoreCoordinator: coordinator)
        
        return coordinator
    }()*/
    
    /*lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()*/
}

