//
//  ImageFile.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/15/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class ImageFile: FileTableViewCell {

    @IBOutlet weak var img: UIImageView!

    override func fill(file:File) {
        super.fill(file)
        self.img.contentMode = .ScaleAspectFit

        dispatch_async(dispatch_get_main_queue()) {
            if let screenshot = file.screenshot {
                if let url = NSURL(string: screenshot) {
                    if let data = NSData(contentsOfURL: url) {
                        self.img.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
