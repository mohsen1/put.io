//
//  MusicFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/13/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class   MusicFileViewController: FileViewController {

    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
    }
    
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "MusicFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    @IBAction func startPlaying(sender: AnyObject) {
        NSLog("Playing \(file?.name)")
    }
}
