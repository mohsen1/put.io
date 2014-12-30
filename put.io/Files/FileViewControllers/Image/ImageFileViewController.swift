//
//  ImageViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/8/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import Alamofire

class ImageFileViewController: FileViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var openButton: UIButton!
    
    var fullImageUrl:NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
        loadScreenshot()
        downloadFullImage()
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
    
    func downloadFullImage() {
        if file != nil {
            FileStore.getDownloadUrl(file!.id) { (url:NSURL?) in
                if url != nil {
                    Alamofire.download(.GET, url!, { (temporaryURL, response) in
                        if let directoryURL = NSFileManager.defaultManager()
                            .URLsForDirectory(.DocumentDirectory,
                                inDomains: .UserDomainMask)[0]
                            as? NSURL {
                                let pathComponent = response.suggestedFilename
                                self.fullImageUrl = directoryURL.URLByAppendingPathComponent(pathComponent!)
                                return self.fullImageUrl!
                        }
                        self.fullImageUrl = temporaryURL
                        return temporaryURL
                    })
                    .response { (request, response, _, error) in
                        self.navigationItem.title = "✔︎ \(self.file!.name!)"
                        self.openButton.hidden = false
                    }
                }
                
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
