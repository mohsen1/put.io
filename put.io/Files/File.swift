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
    @NSManaged var id: String
    @NSManaged var parent_id: String
    @NSManaged var name: String
    @NSManaged var content_type: String
    @NSManaged var isFolder: Bool
//    @NSManaged var parent: File
//    @NSManaged var children: NSSet
    
    func fillWithJson(json:NSDictionary){
        if let _name = json["name"] as? String {
            name = _name
        }
        if let _id = json["id"] as? Int {
            id = String(_id)
        }
        if let _parent_id = json["parent_id"] as? Int {
            parent_id = String(_parent_id)
        }
        if let _content_type = json["content_type"] as? String {
            content_type = _content_type
        }
        
        
        // Determine if it's a folder and assign children
        if content_type == "application/x-directory" {
            isFolder = true
//            FileStore.getFolder(id, { (files:[File]) in self.children = files})
        }
    }
}