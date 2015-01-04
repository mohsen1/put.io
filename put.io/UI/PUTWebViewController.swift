//
//  PUTWebViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 1/4/15.
//  Copyright (c) 2015 Mohsen Azimi. All rights reserved.
//

import UIKit

class PUTWebViewController: UIViewController, UIWebViewDelegate {

    convenience init(title: String, URL: NSURL) {
        self.init()
        self.navigationItem.title = title
        let webView = UIWebView() as UIWebView
        webView.loadRequest(NSURLRequest(URL: URL))
        webView.delegate = self
        self.view = webView
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == .LinkClicked {
            UIApplication.sharedApplication().openURL(request.URL)
            return false
        }
        return true
    }
}
