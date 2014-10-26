    //
//  FileStore.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/24/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import CoreData
import SwiftHTTP

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
    
    class func getFolder (id:Int, completionHandler: ([File])->()) {
        var error: NSError? = nil
        var fetchReq = NSFetchRequest(entityName: "File")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)
        
        fetchReq.predicate = NSPredicate(format: "parent_id == \(id)")
        fetchReq.sortDescriptors = [sorter]
        
        if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [File]{
            
            if result.count > 0 {
                completionHandler(result)
            } else {
                fetchList(id, completionHandler: completionHandler)
            }
        }
        
    }
    
    class func getFile (id:Int, completionHandler: (File)->()) {
        var error: NSError? = nil
        var fetchReq = NSFetchRequest(entityName: "File")
        
        fetchReq.predicate = NSPredicate(format: "id == \(id)")
        
        if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [File]{
            
            if result.count > 0 {
                completionHandler(result[0])
            } else {
                fetchList(id, completionHandler: { fetchResult in
                    completionHandler(fetchResult[0])
                })
            }
        }
    }
    
    // MARK: - HTTP
    private class func fetchList(id:Int, completionHandler: ([File])->()) {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/files/list"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            let params = [
                "oauth_token": "\(account.token!)",
                "parent_id": "\(id)"
            ]
        } else {
            print("Not logged in and trying to access files")
        }
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    if let jsonFiles = json["files"] as? NSArray {
                        let resultFiles = FileStore.filesFromJsonArray(jsonFiles) as [File]
                        appDelegate.cdh.saveContext(appDelegate.cdh.managedObjectContext!)
                        
                        completionHandler(resultFiles)
                    }
                    
                }
            }
            }, failure: {(error: NSError, response: HTTPResponse?) in
                // TODO
                print(error)
        })
    }

    
}
