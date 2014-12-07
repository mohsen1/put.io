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
    case TEXT
    case FOLDER
    case PLAIN
}

class Types {
    class func typeFor(contentType: String) -> FileType {
        let stringMatchTypes:[FileType:String] = [
            .VIDEO: "video/",
            .IMAGE: "image/",
            .AUDIO: "audio/",
            .PDF: "application/pdf",
            .TEXT: "text/",
            .FOLDER: "application/x-directory"
        ]

        for item:(type:FileType, stringMatch:String) in stringMatchTypes {
            if let range = contentType.rangeOfString(item.stringMatch) {
                return item.type
            }
        }

        return FileType.PLAIN
    }
    class func iconFor(contentType: String) -> UIImage {
        let typeNames:[FileType:String] = [
            .VIDEO:  "Video",
            .IMAGE:  "Image",
            .AUDIO:  "Audio",
            .PDF:    "PDF",
            .TEXT:   "Text",
            .FOLDER: "Folder",
            .PLAIN:  "Plain"
        ];

        let type = self.typeFor(contentType)
        return UIImage(named: typeNames[type]! + "Icon")!
    }
}
