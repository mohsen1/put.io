//
//  VideoFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/27/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import MediaPlayer
import Haneke

class VideoFileViewController: FileViewController {
    @IBOutlet var screenshot: UIImageView!
    @IBOutlet var playButton: UIButton!
    var streamUrl:NSURL?
    var vcs:[AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        
        dispatch_async(dispatch_get_main_queue()){
            self.loadScreenshot()
            self.getStreamUrl()
        }
    }
    
    func loadScreenshot() {
        if let screenshot = file?.screenshot {
            if let url = NSURL(string: file!.screenshot!) {
                self.screenshot.hnk_setImageFromURL(url)
            }
        }
    }
    
    func getStreamUrl() {
        if self.file != nil {
            FileStore.getDownloadUrl(file!.id) { (url:NSURL?) in
                self.streamUrl = url
                dispatch_async(dispatch_get_main_queue()) {
                    self.playButton.hidden = false
                }
            }
        }
    }
    
    @IBAction func startPlaying(sender: UIButton) {
        if streamUrl != nil {
            let player = MPMoviePlayerViewController(contentURL: streamUrl!)
            player.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            player.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            navigationController?.presentMoviePlayerViewControllerAnimated(player)
            player.moviePlayer.fullscreen = true
            player.moviePlayer.prepareToPlay()
            player.moviePlayer.play()
        }
    }

    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "VideoFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
}
