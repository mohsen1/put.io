//
//  UserManager.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import CoreData

private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

class AccountStore {
    
    private class func createEmptyAccount() -> Account {
        // NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc];
        var entityDescription = NSEntityDescription.entityForName("Account", inManagedObjectContext: appDelegate.cdh.managedObjectContext!)
        

        var account = Account(entity: entityDescription!, insertIntoManagedObjectContext:appDelegate.cdh.managedObjectContext!)
        
        return account
    }
    
    class func deleteAccount() {
        var account = getAccount()
        appDelegate.cdh.managedObjectContext!.deleteObject(account)
    }
    
    class func updateAccount(json:NSDictionary) {
        var account = getAccount()
        
        account.fill(json)
        saveAccount()
    }
    
    class func getAccount() -> Account {
        var error: NSError? = nil
        var fetchReq = NSFetchRequest(entityName: "Account")
        
        if let accounts = appDelegate.cdh.managedObjectContext!.executeFetchRequest(fetchReq, error:&error) as? [Account]{
            

            if accounts.count > 0 {
                return accounts[0]
            }
        }
        let account = createEmptyAccount()
        return account
        
    }
    
    class func saveAccount() {
        appDelegate.cdh.saveContext(appDelegate.cdh.managedObjectContext!)
    }
}
