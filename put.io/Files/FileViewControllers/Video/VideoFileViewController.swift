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

    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        
        dispatch_async(dispatch_get_main_queue()){
            self.loadScreenshot()
        }
    }
    
    func loadScreenshot() {
        if self.file != nil {
            self.screenshot.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.file!.screenshot!)!)!)
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
