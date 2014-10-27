//
//  LoginViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UIWebViewDelegate {
    
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!

    
   
    func FinishLogin(token:String) {
        println("Init acount with token: \(token)")
        AccountStore.initAccount(token, { _ in
            println("account init callback")
            dispatch_async(dispatch_get_main_queue()) {
                self.tabBarController?.tabBar.hidden = false
                self.tabBarController?.selectedIndex = 0
                self.navigationController?.setNavigationBarHidden(false, animated: false)
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        })
    }
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "LoginViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.hidden = true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        startRequest()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingActivityIndicator.hidden = false
        loadingActivityIndicator.startAnimating()
        loadingMessageLabel.text = "Loading..."
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        println("webViewDidFinishLoad")
        
        let js = "document.querySelector('img').remove();" +
            "document.querySelector('h1').innerText = 'Please login';" +
            "document.querySelector('form').style.textAlign = 'center';" +
            "document.querySelector('[name=\"name\"]').style.margin = '1em auto';" +
            "document.querySelector('[name=\"password\"]').style.margin = '2em auto';"
        let currentUrl = webView.stringByEvaluatingJavaScriptFromString("window.location.href")
        
        println("current url is \(currentUrl!)")
        
        loadingActivityIndicator.hidden = true
        loadingActivityIndicator.stopAnimating()
        loadingMessageLabel.text = ""
        
        if currentUrl?.rangeOfString("/login") != nil {
            webView.stringByEvaluatingJavaScriptFromString(js)
        }

        if let token = webView.stringByEvaluatingJavaScriptFromString("if(location.hash.indexOf('access_token=') > -1) location.hash.split('=')[1]") {
                if token != "" {
                    FinishLogin(token)
                }

        }
    }

    @IBAction func refresh(sender: AnyObject) {
        loginWebView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
        startRequest()
    }
    
    
    func startRequest() {
        let startUrl = "https://api.put.io/v2/oauth2/authenticate?client_id=1655&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        var startRequest = NSMutableURLRequest(URL: NSURL(string: startUrl)!)
        
        loadingActivityIndicator.hidden = false
        loadingActivityIndicator.startAnimating()
        loadingMessageLabel.text = "Loading..."
        
        loginWebView.delegate = self
        loginWebView.loadRequest(startRequest)
    }
}
