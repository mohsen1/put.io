//
//  FileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class PlainFileViewController: FileViewController {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!

    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "PlainFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }

    override func viewWillAppear(animated: Bool) {
        navigationItem.title = file?.name
        icon.image = UIImage(named: "PlainIcon")
        nameLabel.text = file?.name
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = NSLineBreakMode.ByCharWrapping
        sizeLabel.text = "Size: 1Bytes"
    }
}
