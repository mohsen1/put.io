//
//  FolderTableViewCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/29/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

private let byteFormatter = NSByteCountFormatter()

class FolderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var fileAccessed: UILabel!
    
    func fill(file:File) {
        self.fileName.text = file.name
        self.icon.image = Types.iconFor(file.content_type!)
        
        if file.size != nil {
            // All this dance because XCode is not supporting Ints in core data properly!
            let nsSizeStr = NSString(string: file.size!)
            self.fileSize.text = byteFormatter.stringFromByteCount(Int64(nsSizeStr.intValue))
        }

        if !file.isFolder && (file.first_accessed_at != nil) {
            self.fileAccessed.text = "accessed"
        } else {
            self.fileAccessed.text = ""
        }
    }
}
