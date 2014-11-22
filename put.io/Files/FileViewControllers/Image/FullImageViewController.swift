//
//  FullImageViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/22/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {
    var file:File?
    @IBOutlet weak var img: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if file != nil {
            if let screenshot = file!.screenshot {
                if let url = NSURL(string: screenshot) {
                    if let data = NSData(contentsOfURL: url) {
                        self.img.image = UIImage(data: data)
                    }
                }
            }
        }
    }

}
