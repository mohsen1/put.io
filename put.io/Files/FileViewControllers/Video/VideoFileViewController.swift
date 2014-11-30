//
//  VideoFile.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/15/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import MediaPlayer

class VideoFileViewController: FileViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var img: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func play(sender: AnyObject) {
        FileStore.getDownloadUrl(file!.id, completionHandler: {(url:NSURL?) in
            if url != nil {
                let player = MPMoviePlayerController(contentURL: url!)

                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("MPMoviePlayerDidExitFullscreenNotification:"), name: MPMoviePlayerDidExitFullscreenNotification, object: player)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("loadStateChanged:"), name: MPMoviePlayerLoadStateDidChangeNotification, object: player)

                player.shouldAutoplay = true
                player.movieSourceType = .Streaming
                player.prepareToPlay()
//                self.addSubview(player.view)
                player.setFullscreen(true, animated: true)
            }

        })
    }

    func loadStateChanged(notification:NSNotification) {
        let player = notification.object as MPMoviePlayerController
        println("loadStateChanged")
        println(player.loadState)
    }

    func moviePlayBackDidFinish(notification:NSNotification) {
        let player = notification.object as MPMoviePlayerController
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerDidExitFullscreenNotification, object: player)
        player.stop()
        player.view?.removeFromSuperview()
    }

}
