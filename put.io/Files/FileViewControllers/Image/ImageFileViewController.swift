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
    @IBOutlet weak var openButton: UIButton!
    
    var fullImageUrl:NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        loadScreenshot()
        fetchDownloadUrl()
    }
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "ImageFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    
    func loadScreenshot () {
        if file?.screenshot != nil {
            dispatch_async(dispatch_get_main_queue()){
                if let url = NSURL(string: self.file!.screenshot!) {
                    if let data = NSData(contentsOfURL: url){
                        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
                        self.imageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func fetchDownloadUrl() {
        if file != nil {
            FileStore.getDownloadUrl(file!.id) { (url:NSURL?) in
                self.fullImageUrl = url
                self.openButton.hidden = false
            }
        }
    }
    
    @IBAction func openFull(sender: UIButton) {
        var vc = FullImageFileViewController()
        vc.url = fullImageUrl
        vc.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        navigationController?.presentViewController(vc, animated: false, completion: {})
    }
}
