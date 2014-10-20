//
//  AccountViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AccountViewController: UITableViewController, UIWebViewDelegate {

    func login(){
        let url = "https://api.put.io/v2/oauth2/authenticate?client_id=1655" +
            "&response_type=token&redirect_uri=http://mohsenweb.com/put.io/"
        var webView = UIWebView()
        let URL = NSURL(string: url)
        
        webView.delegate = self
        view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: URL))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let fragment:NSString? = webView.request!.URL.fragment
        let url = webView.request!.URL.standardizedURL
        let loginJs = "document.querySelector('[name=\"name\"]').value = '';" +
            "document.querySelector('[name=\"password\"]').value = '';" +
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
    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Account"
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell

        
        cell.textLabel?.text = "Login"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
//            openLogin()
            login()
        }

    }

}
