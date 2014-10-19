//
//  LoginWebViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    
    var webView:UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Please login"
        super.viewWillAppear(animated)
        self.webView = UIWebView(frame: self.view.bounds)
        self.view.addSubview(self.webView!)
        self.webView?.delegate = self
        var url = "https://api.put.io/v2/oauth2/authenticate?client_id=1655&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        let URL = NSURL(string: url)
        self.webView?.loadRequest(NSURLRequest(URL: URL))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let fragment:NSString? = self.webView!.request!.URL.fragment
        if (fragment != nil) {
            if let range = fragment?.rangeOfString("access_token=", options: nil) {
                let token = fragment?.substringFromIndex(13) // 13 is "access_token=" length
                UserManager.saveUserToken(token!)
                self.navigationController?.popToRootViewControllerAnimated(false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    // }
    

}
