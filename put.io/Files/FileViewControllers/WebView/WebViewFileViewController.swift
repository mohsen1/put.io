//
//  WebViewFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/6/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class WebViewFileViewController: FileViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var statusLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.text = "Loading..."
        let detailsButton = UIBarButtonItem(title: "Details", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("openDetailsViewController"))
        navigationItem.rightBarButtonItem = detailsButton

        loadFile()
    }

    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "WebViewFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }

    func loadFile() {
        if file != nil {
            FileStore.getDownloadUrl(file!.id, completionHandler: { (url:NSURL?) -> () in
                if url != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.loadWebView(url!)
                    }
                } else {
                    self.statusLabel.text = "Failed to get download link"
                }
            })
        } else {
            statusLabel.text = "Failed to load PDF file"
        }
    }

    func loadWebView(url:NSURL) {
        webView.loadRequest(NSURLRequest(URL: url))
        statusLabel.text = "Loaded"
        webView.hidden = false
    }
}
