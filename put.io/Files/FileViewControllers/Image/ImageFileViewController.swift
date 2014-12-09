//
//  ImageViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/8/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class ImageFileViewController: FileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "ImageFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
}
