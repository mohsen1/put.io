//
//  Icon.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/29/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

enum FileType {
    case VIDEO
    case IMAGE
    case AUDIO
    case PDF
    case FOLDER
    case PLAIN
}

class Types {
    // TODO: do not use string for types. Use a class variable when available
    // class let STRING_TYPES<Int, String> = [ -1: "Plain", 0 : "Video", ...]

    class func typeFor(contentType: String) -> FileType {
        if let range = contentType.rangeOfString("video/") {
            return FileType.VIDEO
        }
        else if let range = contentType.rangeOfString("image/") {
            return FileType.IMAGE
        }
        else if let range = contentType.rangeOfString("audio/") {
            return FileType.AUDIO
        }
        else if let range = contentType.rangeOfString("application/pdf") {
            return FileType.PDF
        }
        else if let range = contentType.rangeOfString("application/x-directory") {
            return FileType.FOLDER
        }
        return FileType.PLAIN
    }
    class func iconFor(contentType: String) -> UIImage {
        let typeNames = [
            FileType.VIDEO: "Video",
            FileType.IMAGE: "Image",
            FileType.AUDIO: "Audio",
            FileType.PDF: "PDF",
            FileType.FOLDER: "Folder",
            FileType.PLAIN: "Plain"
        ];
        
        
        let type = self.typeFor(contentType)
        return UIImage(named: typeNames[type]! + "Icon")!
    }
}
