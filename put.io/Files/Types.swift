//
//  Icon.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/29/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class Types {
    // TODO: do not use string for types. Use a class variable when available
    // class let STRING_TYPES<Int, String> = [ -1: "Plain", 0 : "Video", ...]

    class func typeFor(contentType: String) -> String? {
        if let range = contentType.rangeOfString("video/") {
            return "Video"
        }
        if let range = contentType.rangeOfString("image/") {
            return "Image"
        }
        if let range = contentType.rangeOfString("application/x-directory") {
            return "Folder"
        }
        return nil
    }
    class func iconFor(contentType: String) -> UIImage {
        if let type = self.typeFor(contentType) {
            return UIImage(named: type + "Icon")!
        }
        return UIImage(named: "PlainIcon")!
    }
}
