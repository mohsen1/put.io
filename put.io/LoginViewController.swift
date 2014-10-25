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
    var triedUsernamePassword:Bool = false
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBAction func loginTapped(sender: AnyObject) {
        login()
    }
    
    func login(){
        username = usernameField.text
        password = passwordField.text

        username = username.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        password = password.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
        if !username.isEmpty && !password.isEmpty {
            triedUsernamePassword = false
            makeRequest()
        }
    }
    
    func makeRequest(){
        let url = "https://api.put.io/v2/oauth2/authenticate?client_id=1655" +
        "&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        var webView = UIWebView()
        let URL = NSURL(string: url)
        
        spinner.hidden = false
        spinner?.startAnimating()
        webView.delegate = self
        view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: URL!))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let fragment:NSString? = webView.request!.URL.fragment
        let url = webView.request!.URL.standardizedURL
        let loginJs = "document.querySelector('[name=\"name\"]').value = '\(username)';" +
            "document.querySelector('[name=\"password\"]').value = '\(password)';" +
        "document.querySelector('[type=\"submit\"]').click();"
        let range = fragment?.rangeOfString("access_token=")
        let token = fragment?.substringFromIndex(13) // 13 is "access_token=" length
        
        if (fragment != nil) && (range != nil) && (token != nil){
            FinishLogin(token!)
        } else if !triedUsernamePassword {
            triedUsernamePassword = true
            webView.stringByEvaluatingJavaScriptFromString(loginJs)
        } else {
            passwordField.text = ""
            spinner.hidden = true
        }
    }
    
    func FinishLogin(token:String) {
        UserManager.saveUserToken(token)
        tabBarController?.tabBar.hidden = false;
        tabBarController?.selectedIndex = 0
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.popToRootViewControllerAnimated(false)
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

}
