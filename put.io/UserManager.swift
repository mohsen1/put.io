//
//  UserManager.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    
    class func getUserToken() -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey("token") as String?
    }
    
    class func saveUserToken(token:String) {
         NSUserDefaults.standardUserDefaults().setObject(token, forKey: "token")
    }
    
    class func deleteUserToken() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("token")
    }
}
