//
//  CloudDataManager.swift
//  mybudget
//
//  Created by Azam Rahmat on 11/15/16.
//  Copyright © 2016 Brainload Technologies. All rights reserved.
//

import Foundation


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
            print("File deleted")
            return true
           
        } catch let error as NSError {
            print("Failed deleting files : \(error)")
        }
        //}
        return false
    }
    
    // Move local files to iCloud
    // iCloud will be cleared before any operation
    // No data merging
    
    class func moveFileToCloud(fileName: String) {
        if isCloudEnabled() {
            
            if deleteFilesInDirectory(fileName) // Clear destination
            {
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
    }
    
    // Move iCloud files to local directory
    // Local dir will be cleared
    // No data merging
    
    class func moveFileToCloud(name : String) -> Bool {
        
       if deleteFilesInDirectory(name) // Clear destination
       {
        let fileManager = NSFileManager.defaultManager()
        
        
        
        do {
            try fileManager.setUbiquitous(true,
                                          itemAtURL: DocumentsDirectory.localDocumentsURL!.URLByAppendingPathComponent(name),
                                          destinationURL: DocumentsDirectory.iCloudDocumentsURL!.URLByAppendingPathComponent(name))
            print("Moved to iCloud")
           return true
        } catch let error as NSError {
            print("Failed to move file to Cloud : \(error)")
        }
        }
        return false
        
    }
    
    class func backupNow(name : String) -> Bool
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
                return true
            }
            catch
            {
                
                
                print("Error saving to local DIR")
                
            }
            
            
            
        }
        return false
        
        
    }
    
    
}