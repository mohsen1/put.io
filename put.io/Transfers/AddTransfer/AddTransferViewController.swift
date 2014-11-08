//
//  AddTransferViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/6/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AddTransferViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapper = UITapGestureRecognizer(target: self, action: Selector("bodyTapped:"))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
    }

    func bodyTapped(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    

    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func add(sender: AnyObject) {
    }
}
