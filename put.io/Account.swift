//
//  Account.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/25/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import Foundation
import CoreData

@objc(Account)
class Account : NSManagedObject {
    @NSManaged var avatar_url: String?
    @NSManaged var mail: String?
    @NSManaged var token: String?
    @NSManaged var username: String?
    @NSManaged var disk_avail: Int
    @NSManaged var disk_size: Int
    @NSManaged var disk_used: Int
    
    func fill(json:NSDictionary) {
        if let _username = json["username"] as? String {
            avatar_url = _username
        }
        if let _avatar_url = json["avatar_url"] as? String {
            avatar_url = _avatar_url
        }
        if let _mail = json["mail"] as? String {
            mail = _mail
        }
        if let disk = json["size"] as? NSDictionary {
            disk_avail = disk["avail"] as Int
            disk_size = disk["size"] as Int
            disk_used = disk["used"] as Int
        }
    }
}