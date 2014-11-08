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
    @NSManaged var avatar_url: String
    @NSManaged var mail: String?
    @NSManaged var token: String?
    @NSManaged var username: String?
    @NSManaged var disk_avail: Double
    @NSManaged var disk_size: Double
    @NSManaged var disk_used: Double
    @NSManaged var default_subtitle_language: String?
    @NSManaged var plan_expiration_date: NSDate?
    @NSManaged var is_invisible: NSNumber?
    var invisible: Bool {
        get {
            if is_invisible != nil {
                return Bool(is_invisible!)
            }
            return false
        }
        set {
            is_invisible = NSNumber(bool: newValue)
        }
    }

    func fill(json:NSDictionary) {
        if let _username = json["username"] as? String {
            username = _username
        }
        if let _avatar_url = json["avatar_url"] as? String {
            avatar_url = _avatar_url
        }
        if let _mail = json["mail"] as? String {
            mail = _mail
        }
        if let disk = json["disk"] as? NSDictionary {
            disk_avail = disk["avail"] as Double
            disk_size = disk["size"] as Double
            disk_used = disk["used"] as Double
        }
        if let _default_subtitle_language = json["default_subtitle_language"] as? String {
            default_subtitle_language = _default_subtitle_language
        }
        if let _plan_expiration_date = json["plan_expiration_date"] as? String {
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            plan_expiration_date = formatter.dateFromString(_plan_expiration_date)!
        }
        if let _settings = json["settings"] as? NSDictionary {
            is_invisible = _settings["is_invisible"] as Bool
        }
    }
}