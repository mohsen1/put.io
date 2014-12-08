//
//  UserManager.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

class AccountStore {

    private class func createEmptyAccount() -> Account {
        // NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc];
        var entityDescription = NSEntityDescription.entityForName("Account", inManagedObjectContext: appDelegate.cdh.managedObjectContext!)


        var account = Account(entity: entityDescription!, insertIntoManagedObjectContext:appDelegate.cdh.managedObjectContext!)

        return account
    }

    class func deleteAccount() {
        if let account = getAccountSync() {
            appDelegate.cdh.managedObjectContext!.deleteObject(account)
        }
    }

    class func updateAccount(account:Account, json:NSDictionary) {
        account.fill(json)
        saveAccount()
    }

    class func getAccount(completionHandler: (Account)->()) -> () {
        var error: NSError? = nil
        var fetchReq = NSFetchRequest(entityName: "Account")

        if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [Account]{


            if result.count > 0 && result[0].username != nil{
                completionHandler(result[0])
            }
        }
        let account = createEmptyAccount()
        fetchInfo(account, completionHandler: completionHandler)

    }

    class func getAccountSync() -> Account? {
        var error: NSError? = nil
        var fetchReq = NSFetchRequest(entityName: "Account")

        if let result = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [Account]{

            if result.count > 0 && result[0].username != nil{
                return result[0]
            }
        }
        return nil
    }

    class func initAccount(token:String, completionHandler: (Account)->()) {
        var account = self.createEmptyAccount()
        account.token = token
        self.fetchInfo(account, completionHandler: completionHandler)
    }

    private class func saveAccount() {
        appDelegate.cdh.saveContext(appDelegate.cdh.managedObjectContext!)
    }

    // MARK: - HTTP
    class func fetchInfo(acct: Account, completionHandler: (Account)->()) {
        let url = "https://api.put.io/v2/account/info"
        var params = ["oauth_token": "\(acct.token!)"]

        Alamofire.request(.GET, url, parameters: params).responseJSON { (_, _, data, error) in
            if let json = data as? NSDictionary {
                if let info = json["info"] as? NSDictionary {
                    self.updateAccount(acct, json: info)
                    completionHandler(acct)
                    return
                }
            }
            if error != nil {
                // completionHandler(nil) // TODO Make Account optional and pass nil when there is an error
            }
        }
    }

    class func updateSettings(var settings: [String:AnyObject], completionHandler: (NSError?)->()) {
        let url = "https://api.put.io/v2/account/settings?oauth_token=\(getAccountSync()!.token!)"

        Alamofire.request(.POST, url).responseJSON { (_, _, data, error) in
            if let json = data as? NSDictionary {
                if let result = json["settings"] as? NSDictionary {
                    completionHandler(nil)
                    return
                }
            }
            completionHandler(error)
        }
    }
}
