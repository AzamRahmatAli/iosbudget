//
//  BackupRestoreViewController.swift
//  budget
//
//  Created by Azam Rahmat on 10/7/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import UIKit
import CoreData

class BackupRestoreViewController: UITableViewController {
   
    
   
    
    
    var backupFiles : [String] = []
    var nsurl : NSURL?
    
    
    
    func RestoreBackupFile(fileName: String) {
        
        let alertController = UIAlertController(title: "Restore from \(StringFor.name["appName"]!) Backup", message:  "You are about to restore a previous backup into \(StringFor.name["appName"]!). This will overwrite all existing data in \(StringFor.name["appName"]!). Would you like to continue", preferredStyle: UIAlertControllerStyle.Alert)
        
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
           
            
            if self.checkAndDownloadBackupFile(fileName)
            {
                
                if Restore.clearCoreDataStore()
                {
                    if Restore.restoreBackup(fileName)
                    {
                        Helper.alertUser(self, title: "", message: "Backup restored successfully")
                    }
                    else{
                        Helper.alertUser(self, title: "", message: "Backup failed to restore, please try later")
                    }
                }
                else{
                    Helper.alertUser(self, title: "", message: "Backup failed to restore, please try later")
                }
                
            }
            
            
        }
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("no")
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1
        {
            return backupFiles.count
        }
        return 2 //for section 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            
            if indexPath.row == 1
            {
                let cellb = tableView.dequeueReusableCellWithIdentifier("cellb", forIndexPath: indexPath)
                cellb.detailTextLabel?.text = Helper.backupFrequency.rawValue
                cellb.textLabel!.text = "Auto Backup"
                
                return cellb
            }
            else{
                let cellbn = tableView.dequeueReusableCellWithIdentifier("cellbn", forIndexPath: indexPath)
                
                cellbn.textLabel?.tintColor  = Helper.colors[0]
                return cellbn
            }
            
        }
        else{
            let cellr = tableView.dequeueReusableCellWithIdentifier("cellr", forIndexPath: indexPath)
            
            cellr.textLabel!.text = backupFiles[indexPath.row].asFileName + " - Data "
            return cellr
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        
        return 2
        
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            return "Backup"
        case 1:
            return "Restore"
        default:
            return ""
        }
    }
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String?
    {
        switch section
        {
        case 0:
            if let date = Helper.lastBackupTime
            {
            return "Last backup: " + NSDate.timeAgoSinceDate(date, numericDates: false)
            }
            return ""
        
        default:
            return ""
        }
    }
    
    
    
    func action(name : String)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: name.asFileName  + " - data", preferredStyle: .ActionSheet)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: "Restore", style: .Default)
        { action -> Void in
            self.RestoreBackupFile(name)
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: "Delete", style: .Default)
        { action -> Void in
            if CloudDataManager.deleteFilesInDirectory(name)
            {
                self.loadFiles()
            }
            
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
    }
    
    
    func setBackupFrequencyCoreData(frequency : autoBackupFrequency)
    {
        let request = NSFetchRequest(entityName: "Other")
        
        
        
        if Helper.managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                
                let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                
                queryResult.backupFrequency = frequency.rawValue
                
            }
            catch let error {
                print("error : ", error)
            }
            
            
            
        }
            
        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: Helper.managedObjectContext!) as? Other
        {
            
            
            entity.backupTime = NSDate()
            
        }
        do {
            try Helper.managedObjectContext!.save()
            Helper.backupFrequency = frequency
        } catch {
            print("error")
        }
    }

    func autoBackupAction()
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "", message: "Auto Backup", preferredStyle: .ActionSheet)
        
        let monthly: UIAlertAction = UIAlertAction(title: "Monthly", style: .Default)
        { action -> Void in
            self.setBackupFrequencyCoreData(.Monthly)
            CloudDataManager.autoBackup()
            self.tableView.reloadData()
        }
        actionSheetControllerIOS8.addAction(monthly)
        
        let Weekly: UIAlertAction = UIAlertAction(title: "Weekly", style: .Default)
        { action -> Void in
            
            self.setBackupFrequencyCoreData(.Weekly)
            CloudDataManager.autoBackup()
            self.tableView.reloadData()
        }
        actionSheetControllerIOS8.addAction(Weekly)
        let Daily: UIAlertAction = UIAlertAction(title: "Daily", style: .Default)
        { action -> Void in
            
            self.setBackupFrequencyCoreData(.Daily)
            CloudDataManager.autoBackup()
            self.tableView.reloadData()
        }
        actionSheetControllerIOS8.addAction(Daily)
        let OFF: UIAlertAction = UIAlertAction(title: "OFF", style: .Default)
        { action -> Void in
            
            self.setBackupFrequencyCoreData(.OFF)
            
            self.tableView.reloadData()
        }
        actionSheetControllerIOS8.addAction(OFF)
        self.presentViewController(actionSheetControllerIOS8, animated: true, completion: nil)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        if(indexPath.section == 1)
        {
            self.action(backupFiles[indexPath.row])
        }
        else if(indexPath.row == 0)
        {
            let name = CloudDataManager.backupNowName
            if let value = CloudDataManager.backupNow(name)
            {
               if !value
               {
                Helper.alertUser(self, title: "", message: "Backup failed, please try later")
                }
                else
               {
                Helper.alertUser(self, title: "", message: "Backup complete")
                tableView.reloadData()
                }
            }
            else{
                Helper.alertUser(self, title: "", message: "You need to be signed into iCloud and have \"iCloud Drive\" set to ON. To chnge your settings, go to iPhone Setting > iCloud")
            }
        }
        else  if(indexPath.row == 1)
        {
            autoBackupAction()
        }
        
        
    }
    
    
    

   
    
 
    
  
    
    override func viewWillAppear(animated: Bool) {
        if !CloudDataManager.isCloudEnabled()
        {
            Helper.alertUser(self, title: "", message: "You need to be signed into iCloud and have \"iCloud Drive\" set to ON. To chnge your settings, go to iPhone Setting > iCloud")
        }
    }
    
    

    
    
    func loadFiles()
    {
        backupFiles = []
        let iCloudDocumentsURL = CloudDataManager.DocumentsDirectory.iCloudDocumentsURL
        if  iCloudDocumentsURL != nil {
            
            
            let fileManager: NSFileManager = NSFileManager()
            do{
                
                let fileList = try fileManager.contentsOfDirectoryAtURL(iCloudDocumentsURL!, includingPropertiesForKeys: nil, options:[])
                
                
                for s in fileList {
                    print(s)
                    if String(s).rangeOfString("-backup.txt") != nil
                    {
                        
                        backupFiles.append(s.asFileName)
                        
                        
                    }
                    
                    
                    
                }
                self.tableView.reloadData()
            }
            catch{
                
            }
        } else {
            //backupFile.hidden = false
            //backupFile.text = "iCloud is NOT Active!"
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Backup/Restore"
        loadFiles()
        
    }
    
    
    
    
    
    func checkAndDownloadBackupFile(name : String) -> Bool{
        let iCloudDocumentsURL = CloudDataManager.DocumentsDirectory.iCloudDocumentsURL
        if(iCloudDocumentsURL != nil){
            let file = iCloudDocumentsURL!.URLByAppendingPathComponent(name)
            let filemanager = NSFileManager.defaultManager();
            
            if !filemanager.fileExistsAtPath(file.path!){
                
                if filemanager.isUbiquitousItemAtURL(file) {
                    
                    Helper.alertUser(self, title: "Warning", message: "iCloud is currently busy syncing the backup files. Please try again in a few minutes")
                    
                    
                    do {
                        try filemanager.startDownloadingUbiquitousItemAtURL(file)
                    } catch{
                        print("Error while loading Backup File \(error)")
                    }
                }
                return false
            } else{
                return true
            }
        }
        return true
    }
    
    
    
}

extension NSURL
{
    var asFileName:String {
        let indexa = String(self).endIndex.advancedBy(-21)
        let indexb = String(self).endIndex
        
        return String(self)[indexa..<indexb]
    }
}
extension String
{
    var asFileName:String {
        let indexa = String(self).endIndex.advancedBy(-21)
        let indexb = String(self).endIndex.advancedBy(-12)
        
        return String(self)[indexa...indexb]
    }
}

/*
 @IBAction func sendMessage()
 {
 
 
 let iCloudDocumentsURL = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
 
 //is iCloud working?
 if  iCloudDocumentsURL != nil {
 
 //Create the Directory if it doesn't exist
 if (!NSFileManager.defaultManager().fileExistsAtPath(iCloudDocumentsURL!.path!, isDirectory: nil)) {
 //This gets skipped after initial run saying directory exists, but still don't see it on iCloud
 do
 {
 
 try NSFileManager.defaultManager().createDirectoryAtURL(iCloudDocumentsURL!, withIntermediateDirectories: true, attributes: nil)
 }
 catch let error as NSError {
 error.description
 }
 }
 } else {
 //backupFile.hidden = false
 //backupFile.text = "iCloud is NOT Active!"
 return
 }
 
 
 
 //Set up directorys
 let localDocumentsURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask).last
 
 //Add txt file to my local folder
 let myTextString = NSString(string: Backup.doBackup() ?? "")
 let myLocalFile = localDocumentsURL!.URLByAppendingPathComponent(date)
 do
 {
 
 
 try myTextString.writeToURL(myLocalFile, atomically: true, encoding: NSUTF8StringEncoding)
 }
 catch
 {
 
 
 print("Error saving to local DIR")
 
 }
 
 
 //If file exists on iCloud remove it
 var isDir:ObjCBool = false
 if (NSFileManager.defaultManager().fileExistsAtPath(iCloudDocumentsURL!.path!, isDirectory: &isDir)) {
 do
 {
 
 
 try NSFileManager.defaultManager().removeItemAtURL(iCloudDocumentsURL!)
 }
 catch let error as NSError
 {
 print(error.localizedDescription);
 }
 }
 do{
 
 
 //copy from my local to iCloud
 try NSFileManager.defaultManager().copyItemAtURL(localDocumentsURL!, toURL: iCloudDocumentsURL!)
 
 
 }
 catch let error as NSError
 {
 print(error.localizedDescription);
 }
 
 
 
 //backupFile.text = "New Backup Done"
 //backupFile.hidden = false
 
 
 
 
 }*/

/*
 
 class CloudDataManager {
 
 static let sharedInstance = CloudDataManager() // Singleton
 
 struct DocumentsDirectory {
 static let localDocumentsURL: NSURL? = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
 static let iCloudDocumentsURL: NSURL? = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
 
 }
 
 
 // Return the Document directory (Cloud OR Local)
 // To do in a background thread
 
 func getDocumentDiretoryURL() -> NSURL {
 print(DocumentsDirectory.iCloudDocumentsURL)
 print(DocumentsDirectory.localDocumentsURL)
 return DocumentsDirectory.localDocumentsURL!//DocumentsDirectory.iCloudDocumentsURL!
 
 }
 
 // Return true if iCloud is enabled
 
 func isCloudEnabled() -> Bool {
 if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
 else { return false }
 }
 
 // Delete All files at URL
 
 func deleteFilesInDirectory(url: NSURL?) {
 let fileManager = NSFileManager.defaultManager()
 let enumerator = fileManager.enumeratorAtPath(url!.path!)
 while let file = enumerator?.nextObject() as? String {
 
 do {
 try fileManager.removeItemAtURL(url!.URLByAppendingPathComponent(file))
 print("Files deleted")
 } catch let error as NSError {
 print("Failed deleting files : \(error)")
 }
 }
 }
 
 // Move local files to iCloud
 // iCloud will be cleared before any operation
 // No data merging
 
 func moveFileToCloud() {
 if isCloudEnabled() {
 deleteFilesInDirectory(DocumentsDirectory.iCloudDocumentsURL!) // Clear destination
 let fileManager = NSFileManager.defaultManager()
 let enumerator = fileManager.enumeratorAtPath(DocumentsDirectory.localDocumentsURL!.path!)
 while let file = enumerator?.nextObject() as? String {
 
 do {
 try fileManager.setUbiquitous(true,
 itemAtURL: DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(file),
 destinationURL: DocumentsDirectory.iCloudDocumentsURL!.URLByAppendingPathComponent(file))
 print("Moved to iCloud")
 } catch let error as NSError {
 print("Failed to move file to Cloud : \(error)")
 }
 }
 }
 }
 
 // Move iCloud files to local directory
 // Local dir will be cleared
 // No data merging
 
 func moveFileToLocal() {
 
 deleteFilesInDirectory(DocumentsDirectory.localDocumentsURL!)
 let fileManager = NSFileManager.defaultManager()
 let enumerator = fileManager.enumeratorAtPath(DocumentsDirectory.iCloudDocumentsURL!.path!)
 while let file = enumerator?.nextObject() as? String {
 
 do {
 try fileManager.setUbiquitous(false,
 itemAtURL: DocumentsDirectory.iCloudDocumentsURL!.URLByAppendingPathComponent(file),
 destinationURL: DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(file))
 print("Moved to local dir")
 } catch let error as NSError {
 print("Failed to move file to local dir : \(error)")
 }
 }
 }
 
 
 
 
 }
 */