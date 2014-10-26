//
//  LoginViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!

    
   
    func FinishLogin(token:String) {
        AccountStore.initAccount(token, { _ in
            self.tabBarController?.tabBar.hidden = false
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.popToRootViewControllerAnimated(false)
        })
    }
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "LoginViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.hidden = true
        super.viewWillAppear(animated)
    }


    override func viewDidLoad() {
        let startUrl = "https://api.put.io/v2/oauth2/authenticate?client_id=1655&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        var startRequest = NSMutableURLRequest(URL: NSURL(string: startUrl)!)
        
        super.viewDidLoad()
        
        webView.delegate = self
        webView.loadRequest(startRequest)
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        let js = "document.querySelector('img').remove();" +
            "document.querySelector('h1').innerText = 'Please login';" +
            "document.querySelector('form').style.textAlign = 'center';" +
            "document.querySelector('[name=\"name\"]').style.margin = '1em auto';" +
            "document.querySelector('[name=\"password\"]').style.margin = '2em auto';"
        
        webView.stringByEvaluatingJavaScriptFromString(js)
        
        if let fragment:NSString? = webView.request!.URL.fragment {
            if let range = fragment?.rangeOfString("access_token=") {
                if let token = fragment?.substringFromIndex(13) { // 13 is "access_token=" length
                    FinishLogin(token)
                }
            }
        }
    }

}
