//
//  CloudDataManager.swift
//  mybudget
//
//  Created by Azam Rahmat on 11/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation
import CoreData
import Firebase


class CloudDataManager {
    
    
    
    static func checkAndDownloadBackupFile(){
        let iCloudDocumentsURL = CloudDataManager.DocumentsDirectory.iCloudDocumentsURL
        if(iCloudDocumentsURL != nil){
            
            let filemanager = NSFileManager.defaultManager();
            do{
                
                let fileList = try filemanager.contentsOfDirectoryAtURL(iCloudDocumentsURL!, includingPropertiesForKeys: nil, options:[])
                
                
                for s in fileList {
                    //print(s)
                    let str = String(s)
                    if str.rangeOfString("-backup.txt.icloud") != nil
                    {
                        
                        /*let indexa = str.endIndex.advancedBy(-28)
                         let indexb = str.endIndex.advancedBy(-8)
                         
                         let fileName = str[indexa...indexb]
                         let file = iCloudDocumentsURL!.URLByAppendingPathComponent(fileName)
                         print(s)
                         print(file)
                         print(fileName)
                         print(file.path!)
                         if !filemanager.fileExistsAtPath(s.path!){
                         
                         if filemanager.isUbiquitousItemAtURL(s) {
                         
                         Helper.alertUser(self, title: "", message: "iCloud is currently busy syncing the backup files. Please try again in a few minutes")*/
                        FIRAnalytics.setUserPropertyString("backup download request", forName: "backup_restore")
                        
                        do {
                            try filemanager.startDownloadingUbiquitousItemAtURL(s)
                        } catch let nsError as NSError{
                            Helper.fireBaseSetUserProperty(nsError)
                            //print("Error while loading Backup File \(error)")
                        }/*
                         }
                         return false
                         } else{
                         return true
                         }
                         
                         
                         
                         }
                         }
                         }
                         
                         catch let nsError as NSError{
                         Helper.fireBaseSetUserProperty(nsError)
                         
                         }
                         }
                         return true*/
                        
                    }
                }
            }
                
            catch let nsError as NSError{
                Helper.fireBaseSetUserProperty(nsError)
                
            }
        }
    }
    
    
    static var backupNowName : String
    {
        let date = String(NSDate())
        return date[date.startIndex...date.startIndex.advancedBy(9)] + "-backup.txt"
    }
    static let sharedInstance = CloudDataManager() // Singleton
    
    struct DocumentsDirectory {
        static let localDocumentsURL: NSURL? = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: .UserDomainMask).last! as NSURL
        static let iCloudDocumentsURL: NSURL? = NSFileManager.defaultManager().URLForUbiquityContainerIdentifier(nil)?.URLByAppendingPathComponent("MBBackup")
        
    }
    
    
    // Return the Document directory (Cloud OR Local)
    // To do in a background thread
    
    func getDocumentDiretoryURL() -> NSURL {
        //print(DocumentsDirectory.iCloudDocumentsURL)
        //print(DocumentsDirectory.localDocumentsURL)
        return DocumentsDirectory.localDocumentsURL!//DocumentsDirectory.iCloudDocumentsURL!
        
    }
    
    // Return true if iCloud is enabled
    
    class func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else { return false }
    }
    
    // Delete All files at URL
    
    class func deleteFilesInDirectory(fileName: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        //let enumerator = fileManager.enumeratorAtPath(url!.path!)
        //while let file = enumerator?.nextObject() as? String {
        let iCloudDocumentsURL = CloudDataManager.DocumentsDirectory.iCloudDocumentsURL
        let url = iCloudDocumentsURL!.URLByAppendingPathComponent(fileName)
        do {
            try fileManager.removeItemAtURL(url)
            //print("File deleted")
            return true
            
        } catch let nsError as NSError{
            Helper.fireBaseSetUserProperty(nsError)
            //Helper.fireBaseSetUserProperty(nsError)
            //print("Failed deleting files : \(error)")
        }
        //}
        return false
    }
    
    
    
    // Move iCloud files to local directory
    // Local dir will be cleared
    // No data merging
    
    class func moveFileToCloud(name : String) -> Bool {
        
        deleteFilesInDirectory(name) // Clear destination
        
        let fileManager = NSFileManager.defaultManager()
        
        
        
        do {
            try fileManager.setUbiquitous(true,
                                          itemAtURL: DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(name),
                                          destinationURL: DocumentsDirectory.iCloudDocumentsURL!.URLByAppendingPathComponent(name))
            //print("Moved to iCloud")
            
            return true
        } catch let nsError as NSError{
            Helper.fireBaseSetUserProperty(nsError)
            //print("Failed to move file to Cloud : \(error)")
        }
        
        return false
        
    }
    
    
    
    private class func timeAgoSinceDate(date:NSDate)  {
        let calendar = NSCalendar.currentCalendar()
        let now = NSDate()
        let earliest = now.earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:NSDateComponents = calendar.components([NSCalendarUnit.Minute , NSCalendarUnit.Hour , NSCalendarUnit.Day , NSCalendarUnit.WeekOfYear , NSCalendarUnit.Month , NSCalendarUnit.Year , NSCalendarUnit.Second], fromDate: earliest, toDate: latest, options: NSCalendarOptions())
        
        switch Helper.backupFrequency {
        case .Daily:
            if (components.day >= 1)
            {
                backupNow(backupNowName)
            }
        case .Monthly:
            if (components.month >= 1)
            {
                backupNow(backupNowName)
            }
        case .Weekly:
            if (components.weekOfYear >= 1)
            {
                backupNow(backupNowName)
            }
        default:
            break
            
            
        }
        
        
        
    }
    
    class func autoBackup()
    {
        
        if (Helper.backupFrequency != autoBackupFrequency.OFF && CloudDataManager.isCloudEnabled())
        {
            if let lastBackupDate = Helper.lastBackupTime
            {
                timeAgoSinceDate(lastBackupDate)
            }
            else{
                //print("time = ",NSDate(timeIntervalSinceReferenceDate: 0 ))
                timeAgoSinceDate(NSDate(timeIntervalSinceReferenceDate: 0 ))
            }
            Helper.FIRAnalyticsLogEvent("id-auto_backup", value: "auto_backup")
            
            
        }
        
        
    }
    
    class func backupNow(name : String) -> Bool?
    {
        
        
        
        //is iCloud working?
        if  isCloudEnabled() {
            let iCloudDocumentsURL = DocumentsDirectory.iCloudDocumentsURL
            
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
            
            
            
            
            //Set up directorys
            
            
            //Add txt file to my local folder
            let myTextString = NSString(string: Backup.doBackup() ?? "")
            let myLocalFile = DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(name)
            do
            {
                
                
                try myTextString.writeToURL(myLocalFile, atomically: true, encoding: NSUTF8StringEncoding)
                self.setLastBackupTime()
                return moveFileToCloud(name)
            }
            catch let nsError as NSError{
                Helper.fireBaseSetUserProperty(nsError)
                
                //print("Error saving to local DIR")
                
            }
            
            
            
        }
        else{
            return nil
        }
        return false
        
        
    }
    private class func setLastBackupTime()
    {
        let request = NSFetchRequest(entityName: "Other")
        
        
        
        if Helper.managedObjectContext!.countForFetchRequest( request , error: nil) > 0
        {
            
            do{
                
                
                let queryResult = try Helper.managedObjectContext?.executeFetchRequest(request).first as! Other
                
                queryResult.backupTime = NSDate()
                
                
            }
            catch let nsError as NSError{
                Helper.fireBaseSetUserProperty(nsError)
                //print("error : ", error)
            }
            
            
            
        }
        else if let entity = NSEntityDescription.insertNewObjectForEntityForName("Other", inManagedObjectContext: Helper.managedObjectContext!) as? Other
        {
            
            
            entity.backupTime = NSDate()
            
        }
        
        do {
            try Helper.managedObjectContext!.save()
            Helper.lastBackupTime = NSDate()
        } catch let nsError as NSError{
            Helper.fireBaseSetUserProperty(nsError)
            //print("error")
        }
        
    }
    
    
    
    
}