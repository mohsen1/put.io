//
//  FolderTableViewCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/29/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileSize: UILabel!
    @IBOutlet weak var fileAccessed: UILabel!
    
    func fill(file:File) {
        self.fileName.text = file.name
        self.fileSize.text = "\(file.size)"
        self.fileAccessed.text = "accessed"
        self.icon.image = Types.iconFor(file.content_type!)
    }
}
