    //
//  FileStore.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/24/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import CoreData

private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
class FileStore {
    class func newFile(json: NSDictionary)-> File {
        var file = NSEntityDescription.insertNewObjectForEntityForName("File", inManagedObjectContext: appDelegate.cdh.managedObjectContext!) as File
        file.fillWithJson(json)
        
        return file
    }
    
    class func getAll ()-> [File]? {
        let fetchRequest = NSFetchRequest(entityName: "File")
        if let files = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [File] {
            return files
        }
        return nil
    }
    
    class func filesFromJsonArray(array: NSArray)-> NSArray{
        var result = NSMutableArray()
        for item in array {
            if let f = item as? NSDictionary {
                result.addObject(newFile(f))
            }
        }
        
        return result as NSArray
    }
    
}
