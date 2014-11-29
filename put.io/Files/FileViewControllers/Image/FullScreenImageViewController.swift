//
//  FullIScreenmageViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/23/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    var file:File?
    var webview:UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        webview = UIWebView()
        webview!.frame = navigationController!.view.frame
        webview!.scalesPageToFit = true
        view.addSubview(webview!)
        let htmlUrl = NSBundle.mainBundle().URLForResource("FullScreenImage", withExtension: "html")!
        webview!.loadRequest(NSURLRequest(URL:htmlUrl))
        if file != nil {
          load()
        }
    }

    func load() {
      FileStore.getDownloadUrl(file!.id, completionHandler: { (url:NSURL?) in
        if url != nil {
          dispatch_async(dispatch_get_main_queue()) {
            self.webview!.loadRequest(NSURLRequest(URL: url!))
          }
        }
      })
    }
}
