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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
