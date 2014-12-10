//
//  ImageViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/8/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class ImageFileViewController: FileViewController {
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        
        if file?.screenshot != nil {
            dispatch_async(dispatch_get_main_queue()) {
                self.loadScreenshot()
            }
        }
//        FileStore.getDownloadUrl(file!.id) { (url:NSURL?) in
//            if url != nil {
//                dispatch_async(dispatch_get_main_queue()){
//
//                }
//            }
//        }
    }
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "ImageFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    
    func loadScreenshot () {
        if let url = NSURL(string:file!.screenshot!) {
            if let data = NSData(contentsOfURL: url){
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.image = UIImage(data: data)
            }
        }
    }
}
