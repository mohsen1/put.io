//
//  VideoFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/27/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class VideoFileViewController: FileViewController {
    @IBOutlet var screenshot: UIImageView!
    @IBOutlet var playButton: UIButton!
    var streamUrl:NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        
        dispatch_async(dispatch_get_main_queue()){
            self.loadScreenshot()
            self.getStreamUrl()
        }
    }
    
    func loadScreenshot() {
        if self.file != nil {
            // TODO: cache the screenshot
            self.screenshot.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.file!.screenshot!)!)!)
            self.playButton.hidden = false
        }
    }
    
    func getStreamUrl() {
        if self.file != nil {
            FileStore.getDownloadUrl(file!.id) { (url:NSURL?) in
                self.streamUrl = url
            }
        }
    }
    
    @IBAction func startPlaying(sender: UIButton) {
        if streamUrl != nil {

            var player = MPMoviePlayerViewController(contentURL: streamUrl!)
            presentMoviePlayerViewControllerAnimated(player)
            player.moviePlayer.fullscreen = true
            player.moviePlayer.play()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "VideoFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
}
