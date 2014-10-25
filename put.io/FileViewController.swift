//
//  FileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {
    var file:File?
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "FileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Your Files"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let name = self.file?.name {
            self.navigationItem.title = name
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
