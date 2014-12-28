//
//  MusicFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/13/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import AVFoundation


class MusicFileViewController: FileViewController {

    var downloadUrl:NSURL?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        fetchDownloadUrl()
        setDetails()
    }
    
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "MusicFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    @IBAction func startPlaying(sender: AnyObject) {
        if downloadUrl != nil {
            let player = MPMoviePlayerViewController(contentURL: downloadUrl!)
            let defaultNotificationCenter = NSNotificationCenter.defaultCenter()
            player.modalPresentationStyle = UIModalPresentationStyle.OverFullScreen
            player.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            navigationController?.presentMoviePlayerViewControllerAnimated(player)
            player.moviePlayer.fullscreen = true
            player.moviePlayer.prepareToPlay()
            player.moviePlayer.play()
        }
    }
    
    func fetchDownloadUrl() {
        FileStore.getDownloadUrl(file!.id) { (downloadUrl:NSURL?) in
            self.downloadUrl = downloadUrl
            NSLog("download url is \(downloadUrl)")
            dispatch_async(dispatch_get_main_queue()) {
                self.playButton.hidden = false
            }
        }
    }
    
    func setDetails() {
        self.nameLabel.text = file?.name
    }
}
