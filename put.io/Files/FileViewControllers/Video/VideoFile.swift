//
//  VideoFile.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/15/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoFile: FileTableViewCell {
    var file:File?

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func play(sender: AnyObject) {
        let download = "http://api.put.io/v2/files/\(file!.id)/download"
        let url = NSURL(string: download)
        let player = MPMoviePlayerController(contentURL: url)
        player.shouldAutoplay = true
        addSubview(player.view)
        player.setFullscreen(true, animated: true)
    }

    override func fill(file:File) {
        self.file = file
        img.contentMode = .ScaleAspectFit
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

}
