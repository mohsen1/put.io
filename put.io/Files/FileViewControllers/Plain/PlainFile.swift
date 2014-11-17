//
//  PlainFile.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/14/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class PlainFile: FileTableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func fill(file:File) {
        super.fill(file)
        let ns = NSString(string: file.name!)
        label.text = ns.pathExtension.uppercaseString
    }

}
