//
//  TransferStore.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/1/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import Foundation
import SwiftHTTP

private var transfers = [Transfer]()
private let request = HTTPTask()

class TransferStore {
    
    class func getAll(completionHnadler: ([Transfer])->()) {
        let url = "https://api.put.io/v2/transfers/list"
        var params = [String:String]()

        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access transfers")
        }
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    if let arr = json["transfers"] as? NSArray {
                        transfers = []
                        for dic in arr {
                            if let dictionary = dic as? NSDictionary {
                                transfers.append(Transfer(json: dictionary))
                            }
                        }
                    }
                }
                completionHnadler(transfers)
            }
        }, failure: {(error: NSError, response: HTTPResponse?) in
                completionHnadler([])
        })
    }

    class func clean(completionHnadler: (NSError?)->()) {
        let url = "https://api.put.io/v2/transfers/clean"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        }

        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            completionHnadler(nil)
        }, failure: {(error: NSError, response: HTTPResponse?) in
            completionHnadler(error)
            print(error)
        })
    }
    
    class func cancel(transfer: Transfer, completionHander: (NSError?)->()) {
        let account = AccountStore.getAccountSync()
        let url = "https://api.put.io/v2/transfers/cancel"
        var params: Dictionary<String, String> = [
            "transfer_ids": "\(transfer.id)",
            "access_token": "\(account!.token!)"
        ]

        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            completionHander(nil)
        }, failure: {(error: NSError, response: HTTPResponse?) in
            completionHander(error)
        })
    }
    
    class func getOne(transferId: Int64, completionHander: (Transfer?)->()) {
        let url = "https://api.put.io/v2/transfers/\(transferId)"
        var params = [String:String]()
        
        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access a transfer")
        }
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    if let tr = json["transfer"] as? NSDictionary {
                        completionHander(Transfer(json: tr))
                    } else  { completionHander(nil) }
                } else  { completionHander(nil) }
            }
        }, failure: {(error: NSError, response: HTTPResponse?) in
                completionHander(nil)
        })
    }
}