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
    @NSManaged var name: String
    @NSManaged var id: Int
    @NSManaged var parent_id: Int
    
    func fillWithJson(json:NSDictionary){
        if let _name = json["name"] as? String{
            name = _name
        }
        
        if let _id = json["id"] as? Int {
            id = _id
        }
        
        if let _parent_id = json["parent_id"] as? Int {
            parent_id = _parent_id
        }
    }
}