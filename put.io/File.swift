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
    @NSManaged var id: Int
    @NSManaged var parent_id: Int
    @NSManaged var name: String
    @NSManaged var content_type: String
    @NSManaged var isFolder: Bool
    
    func fillWithJson(json:NSDictionary){
        if let _name = json["name"] as? String {
            name = _name
        }
        if let _id = json["id"] as? Int {
            id = _id
        }
        if let _parent_id = json["parent_id"] as? Int {
            parent_id = _parent_id
        }
        if let _content_type = json["content_type"] as? String {
            content_type = _content_type
        }
        
        
        // Determine if it's a folder
        isFolder = content_type == "application/x-directory"
    }
}