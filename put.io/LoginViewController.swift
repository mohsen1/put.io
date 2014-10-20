//
//  LoginViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UIWebViewDelegate {
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func loginTapped(sender: AnyObject) {
        let username = usernameField.text
        let password = passwordField.text
        
        if username != nil && password != nil {
            login()
        }
    }
    func login(){
        let url = "https://api.put.io/v2/oauth2/authenticate?client_id=1655" +
        "&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        var webView = UIWebView()
        let URL = NSURL(string: url)
        
        spinner.hidden = false
        webView.delegate = self
        view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: URL))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let fragment:NSString? = webView.request!.URL.fragment
        let url = webView.request!.URL.standardizedURL
        let loginJs = "document.querySelector('[name=\"name\"]').value = '\(usernameField.text!)';" +
            "document.querySelector('[name=\"password\"]').value = '\(passwordField.text!)';" +
        "document.querySelector('[type=\"submit\"]').click();"
        
        if fragment != nil {
            if let range = fragment?.rangeOfString("access_token=") {
                if let token = fragment?.substringFromIndex(13) { // 13 is "access_token=" length
                    UserManager.saveUserToken(token)
                    tabBarController?.tabBar.hidden = false;
                    tabBarController?.selectedIndex = 0
                }
            }
        } else {
            webView.stringByEvaluatingJavaScriptFromString(loginJs)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        spinner?.hidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
