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
        fetchList(id, completionHandler: completionHandler)
    }
    
    // MARK: - HTTP
    private class func fetchList(id:Int, completionHandler: ([File])->()) {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/files/list"
        var params = Dictionary<String, String>()
        if let token = UserManager.getUserToken() {
            params = [
                "oauth_token": "\(token)",
                "parent_id": "\(id)"
            ]
        }
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    if let jsonFiles = json["files"] as? NSArray {
                        let resultFiles = FileStore.filesFromJsonArray(jsonFiles) as [File]
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
