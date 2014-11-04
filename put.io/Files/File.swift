//
//  File.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/25/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import Foundation
import CoreData

@objc(File)
class File: NSManagedObject {
    @NSManaged var id: NSNumber
    @NSManaged var parent_id: String
    @NSManaged var name: String?
    @NSManaged var content_type: String?
    @NSManaged var isFolder: Bool
    @NSManaged var created_at: NSDate?
    @NSManaged var first_accessed_at: NSDate?
    @NSManaged var is_mp4_available: NSNumber? // 0 false, 1 true
    @NSManaged var is_shared: NSNumber? // 0 fasle, 1 true
    @NSManaged var opensubtitles_hash: String?
    @NSManaged var screenshot: String?
    @NSManaged var size: String?

    func fillWithJson(json:NSDictionary){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if let _name = json["name"] as? String {
            name = _name
        }

        if let _id = json["id"] as? Int {
            id =  NSNumber(integer: _id)
        } else {
            id = NSNumber(integer: -1)
        }

        if let _parent_id = json["parent_id"] as? Int {
            parent_id = String(_parent_id)
        } else {
            parent_id = "0"
        }

        if let _content_type = json["content_type"] as? String {
            content_type = _content_type
        }

        if let _created_at = json["created_at"] as? String {
            created_at = dateFormatter.dateFromString(_created_at)!
        }

        if let _first_accessed_at = json["first_accessed_at"] as? String {
            first_accessed_at = dateFormatter.dateFromString(_first_accessed_at)!
        }

        if let _is_mp4_available = json["is_mp4_available"] as? Bool {
            is_mp4_available = NSNumber(bool: _is_mp4_available)
        }

        if let _is_shared = json["is_shared"] as? Bool{
            is_shared = NSNumber(bool: _is_shared)
        }

        if let _opensubtitles_hash = json["opensubtitles_hash"] as? String {
            opensubtitles_hash = _opensubtitles_hash
        }

        if let _screenshot = json["screenshot"] as? String {
            screenshot = _screenshot
        }

        if let _size = json["size"] as? NSNumber {
            size = "\(_size)"
        }

        // Determine if it's a folder and assign children
        if content_type != nil {
            isFolder = content_type == "application/x-directory"
        } else {
            isFolder = true // Assume it's root folder
        }
    }
}