//
//  LoginViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController , UIWebViewDelegate {
    var username:String = ""
    var password:String = ""
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func loginTapped(sender: AnyObject) {
        login()
    }
    func login(){
        let url = "https://api.put.io/v2/oauth2/authenticate?client_id=1655" +
        "&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        var webView = UIWebView()
        let URL = NSURL(string: url)
        
        username = usernameField.text
        password = passwordField.text

        username = username.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        password = password.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        if !username.isEmpty && !password.isEmpty {
            spinner.hidden = false
            spinner?.startAnimating()
            webView.delegate = self
            view.addSubview(webView)
            webView.loadRequest(NSURLRequest(URL: URL))
        } else {
            
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let fragment:NSString? = webView.request!.URL.fragment
        let url = webView.request!.URL.standardizedURL
        let loginJs = "document.querySelector('[name=\"name\"]').value = '\(username)';" +
            "document.querySelector('[name=\"password\"]').value = '\(password)';" +
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
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "LoginViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        spinner?.hidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Login"
        navigationController?.setNavigationBarHidden(true, animated: false)
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
