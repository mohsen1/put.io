//
//  FileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/30/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {
    var file:File?
    
    @IBOutlet weak var preview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = file?.name
        // Do any additional setup after loading the view.
    }
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "FileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
}
