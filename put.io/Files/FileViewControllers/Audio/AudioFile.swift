//
//  AudioFile.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/28/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AudioFile: FileTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func play(sender: AnyObject) {
        NSLog("Play!")
    }
}
