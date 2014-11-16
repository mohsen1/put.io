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
private let request = HTTPTask()

class FileStore {

    class func newFile(json: NSDictionary)-> File? {
        var error:NSError?
        if let id = json["id"] as? Int {
            var fetchRequest = NSFetchRequest(entityName: "File")
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchRequest, error:&error) as? [File]{
                if result.count == 0 {
                    var file = NSEntityDescription.insertNewObjectForEntityForName("File", inManagedObjectContext: appDelegate.cdh.managedObjectContext!) as File
                    file.fillWithJson(json)
                    saveContext()
                    return file
                } else {
                    result[0].fillWithJson(json)
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
                fetchList(id, completionHandler: completionHandler)
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
        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            var jsonError:NSError?
            if let data = response.responseObject as? NSData {
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    if let jsonFile = json["file"] as? NSDictionary {
                        if let resultFile = FileStore.newFile(jsonFile){
                            completionHandler(resultFile)
                        }
                    }
                }
            }
        }, failure: {(error: NSError, response: HTTPResponse?) in
                // TODO
                println(error)
        })
    }

    class func deleteFiles(ids:[NSNumber], completionHandler: (NSError?)->()) {
        let joiner = ","
        let idsStr = joiner.join(ids.map {(i:NSNumber) -> String in return "\(i.integerValue)"})
        var params:[String:AnyObject] = [
            "oauth_token": "\(AccountStore.getAccountSync()!.token!)",
            "file_ids": "\(idsStr)"
        ]
        let url = "https://api.put.io/v2/files/delete"
        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            completionHandler(nil)
        }, failure: {(error: NSError, response: HTTPResponse?) in
            completionHandler(error)
        })
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
                println(error)
        })
    }

    private class func fetchFile(id:NSNumber, completionHandler: (File)->()) {
        let url = "https://api.put.io/v2/files/\(id)"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params["oauth_token"] = "\(account.token!)"
        } else {
            print("Not logged in and trying to access files")
        }

        request.GET(url, parameters: params, {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    if let jsonFile = json["file"] as? NSDictionary {
                        if let resultFile = FileStore.newFile(jsonFile) {
                            completionHandler(resultFile)
                        }
                    }

                }
            }
        }, failure: {(error: NSError, response: HTTPResponse?) in
            // TODO
            println(error)
        })
    }
}
