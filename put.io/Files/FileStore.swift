//
//  FileStore.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/24/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

class FileStore {

    class func newFile(json: NSDictionary)-> File? {
        var error:NSError?
        if let id = json["id"] as? Int {
            var fetchRequest = NSFetchRequest(entityName: "File")
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchRequest, error:&error) as? [File]{
                if result.count == 0 {
                    let file = File(json: json, insertIntoManagedObjectContext: appDelegate.cdh.managedObjectContext!)
                    saveContext()
                    return file
                } else {
                    result[0].updateWithJson(json)
                    return result[0]
                }
            }
        }
        return nil
    }

    class func getAll()-> [File]? {
        let fetchRequest = NSFetchRequest(entityName: "File")
        if let files = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [File] {
            return files
        }
        return nil
    }

    class func filesFromJsonArray(array: NSArray)-> NSArray{
        var result = NSMutableArray()
        for item in array {
            if let json = item as? NSDictionary {
                if let f = newFile(json) {
                    result.addObject(f)
                }
            }
        }
        return result as NSArray
    }

    class func getDownloadUrl(id:NSNumber, completionHandler: (NSURL?)->()) {
        let token = AccountStore.getAccountSync()!.token!
        let urlStr = "https://api.put.io/v2/files/\(id)/download?oauth_token=\(token)"
        let url = NSURL(string: urlStr)!
        let httpRequest: NSMutableURLRequest = NSMutableURLRequest(URL:url, cachePolicy: .UseProtocolCachePolicy, timeoutInterval:10)
        httpRequest.HTTPMethod = "HEAD"
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(httpRequest, queue: queue, completionHandler: { response, data, error in
            if response == nil {
                completionHandler(nil)
            } else {
                completionHandler(response.URL)
            }
        })
    }

    class func getFolder(id:NSNumber, forceFetch:Bool, completionHandler: ([File])->()) {
        var error: NSError? = nil
        var fetchReq = NSFetchRequest(entityName: "File")
        let sorter: NSSortDescriptor = NSSortDescriptor(key: "name" , ascending: false)

        fetchReq.predicate = NSPredicate(format: "parent_id = \(id)")
        fetchReq.sortDescriptors = [sorter]

        if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [File]{

            if result.count > 0 && !forceFetch {
                completionHandler(result)
            } else {
                self.saveContext()
                fetchList(id, completionHandler: { (resultFiles:[File]) in
                    completionHandler(resultFiles)
                })
            }
        }

    }

    class func getFile (id:NSNumber, completionHandler: (File)->()) {
        var error: NSError?
        var fetchReq = NSFetchRequest(entityName: "File")

        fetchReq.predicate = NSPredicate(format: "id == \(id)")

        if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [File]{

            if result.count > 0 {
                completionHandler(result[0])
            } else {
                fetchFile(id, completionHandler: { fetchResult in
                    completionHandler(fetchResult)
                })
            }
        }
    }

    class func newFolder(name:String, parentId: Int32, completionHandler: (File?)->()) {
        var params:[String:AnyObject] = [
            "oauth_token": "\(AccountStore.getAccountSync()!.token!)",
            "name": name,
            "parent_id": "\(parentId)"
        ]
        let url = "https://api.put.io/v2/files/create-folder"

        Alamofire.request(.POST, url, parameters: params).responseJSON { (_, _, data, error) in
            if let json = data as? NSDictionary {
                if let jsonFile = json["file"] as? NSDictionary {
                    if let resultFile = FileStore.newFile(jsonFile){
                        completionHandler(resultFile)
                    }
                }
            }
        }
    }

    class func deleteFiles(ids:[NSNumber], completionHandler: (NSError?)->()) {
        let joiner = ","
        let idsStr = joiner.join(ids.map {(i:NSNumber) -> String in return "\(i.integerValue)"})
        var params:[String:AnyObject] = [
            "oauth_token": "\(AccountStore.getAccountSync()!.token!)",
            "file_ids": "\(idsStr)"
        ]
        let url = "https://api.put.io/v2/files/delete"

        Alamofire.request(.POST, url, parameters: params).responseJSON { (_, _, data, error) in
            completionHandler(error)
        }
    }

    private class func saveContext() {
        appDelegate.cdh.saveContext(appDelegate.cdh.managedObjectContext!)
    }

    // MARK: - HTTP
    private class func fetchList(id:NSNumber, completionHandler: ([File])->()) {
        let url = "https://api.put.io/v2/files/list"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params["oauth_token"] = "\(account.token!)"
        } else {
            print("Not logged in and trying to access files")
        }
        params["parent_id"] = "\(id)"

        Alamofire.request(.GET, url, parameters: params).responseJSON { (_, _, data, error) in
            if let json = data as? NSDictionary {
                if let jsonFiles = json["files"] as? NSArray {
                    let resultFiles = FileStore.filesFromJsonArray(jsonFiles) as [File]
                    completionHandler(resultFiles)
                    return
                }
            }

            // TODO fail better
            completionHandler([])

            if error != nil {
                println(error!)
            }
        }
    }

    private class func fetchFile(id:NSNumber, completionHandler: (File)->()) {
        let url = "https://api.put.io/v2/files/\(id)"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params["oauth_token"] = "\(account.token!)"
        } else {
            print("Not logged in and trying to access files")
        }
        Alamofire.request(.GET, url, parameters: params).responseJSON { (_, _, data, error) -> Void in
            if let json = data as? NSDictionary {
                if let jsonFile = json["file"] as? NSDictionary {
                    if let resultFile = FileStore.newFile(jsonFile) {
                        completionHandler(resultFile)
                        return
                    }
                }
            }

            if error != nil {
                println(error!)
            }
        }
    }
}
