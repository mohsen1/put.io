//
//  TransferStore.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/1/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

private var transfers = [Transfer]()
private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

class TransferStore {

    class func getAll(completionHnadler: ([Transfer])->()) {
        let url = "https://api.put.io/v2/transfers/list"
        var params = [String:String]()

        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access transfers")
        }
        Alamofire.request(.GET, url, parameters: params).responseJSON { (_, _, data, error) in
            if let json = data as? NSDictionary {
                if let arr = json["transfers"] as? NSArray {
                    transfers = []
                    for dic in arr {
                        if let dictionary = dic as? NSDictionary {
                            transfers.append(Transfer(json: dictionary))
                        }
                    }
                    completionHnadler(transfers)
                    return
                }
            }
            completionHnadler([])
        }
    }

    class func clean(completionHnadler: (NSError?)->()) {
        let url = "https://api.put.io/v2/transfers/clean"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        }
        Alamofire.request(.POST, url, parameters: params).responseJSON { (_, _, data, error) in
            if error == nil {
                completionHnadler(nil)
            } else {
                completionHnadler(error)
                NSLog("\(error)")
            }
        }
    }

    class func cancel(transfer: Transfer, completionHandler: (NSError?)->()) {
        let account = AccountStore.getAccountSync()
        let url = "https://api.put.io/v2/transfers/cancel"
        var params: Dictionary<String, String> = [
            "transfer_ids": "\(transfer.id)",
            "oauth_token": "\(account!.token!)"
        ]

        Alamofire.request(.POST, url, parameters: params).responseJSON { (_, _, data, error) in
            if error == nil {
                completionHandler(nil)
            } else {
                completionHandler(error)
                NSLog("\(error)")
            }
        }
    }

    class func add(url:String, completionHandler: (success:Bool)->()){
        let token = AccountStore.getAccountSync()!.token!
        let params = [
            "url": url,
            "extract": "True",
            "save_parent_id": "0",
            "oauth_token": token
        ]
        let url = "https://api.put.io/v2/transfers/add"

        Alamofire.request(.POST, url, parameters: params).response { (_, _, _, error) in
            if error == nil {
                NSLog("error adding transfer \(error?.localizedDescription)")
                completionHandler(success: true)
            } else {
                completionHandler(success: false)
                NSLog("\(error)")
            }
        }
    }

    class func getOne(transferId: NSInteger, completionHander: (Transfer?)->()) {
        let url = "https://api.put.io/v2/transfers/\(transferId)"
        var params = [String:String]()

        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access a transfer")
        }

        Alamofire.request(.GET, url, parameters: params).responseJSON { (_, _, data, error) in
            if let json = data as? NSDictionary {
                if let tr = json["transfer"] as? NSDictionary {
                    completionHander(Transfer(json: tr))
                } else  {
                    completionHander(nil)
                }
                return
            }
            completionHander(nil)
        }
    }

    private class func saveContext() {
        appDelegate.cdh.saveContext(appDelegate.cdh.managedObjectContext!)
    }

    class func fetchFile(transfer: Transfer, completionHandler: (File)->()) {
        FileStore.getFile(transfer.fileId, forceFetch:false) {
            transfer.file = $0
            self.saveContext()
            completionHandler($0)
        }
    }
}