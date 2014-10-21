//
//  UserManager.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

private var token:String?
private let fileName = "token.secret"

class UserManager: NSObject {
    class func getUserToken() -> String? {
        if token != nil {
            return token
        } else {
            if (NSFileManager.defaultManager().fileExistsAtPath(fileName)) {
                token = NSString.stringWithContentsOfFile(fileName, encoding: NSUTF8StringEncoding, error: nil) as String
                return token
            }
            return nil
        }
    }
    
    class func saveUserToken(token_:String) {
        token = token_
        storeToken(token!)
    }
    
    class func deleteUserToken() {
        token = nil
        NSFileManager.defaultManager().removeItemAtPath(fileName, error: nil)
    }
}


func storeToken(token:NSString) {
    let tokenData = token.dataUsingEncoding(NSUTF8StringEncoding)
    NSFileManager.defaultManager().createFileAtPath(fileName, contents: tokenData, attributes: [NSFileProtectionKey: NSFileProtectionComplete])
    
}