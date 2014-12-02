//
//  PlainFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/30/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class PlainFileViewController: FileViewController {

    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var extensionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if file != nil {
            let ns = NSString(string: file!.name!)
            extensionLabel.text = ns.pathExtension.uppercaseString
            fileNameLabel.text = file!.name
            navigationItem.title = file?.name
        }
    }
    
    override func loadView() {
        super.loadView()
        
        let nib = UINib(nibName: "PlainFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    @IBAction func openDetails(sender: AnyObject) {
        super.openDetailsViewController()
    }
}
