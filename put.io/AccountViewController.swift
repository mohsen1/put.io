//
//  AccountViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class AccountViewController: UITableViewController, UIAlertViewDelegate {
    var info = NSDictionary()
    
    func openLogin() {
        UserManager.deleteUserToken()
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Account"
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        
        let logout = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "openLogin")
        navigationItem.rightBarButtonItem = logout
        self.fetchList()
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if UserManager.getUserToken() == nil {
            openLogin()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - HTTP
    func fetchList() {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/account/info"
        var params = Dictionary<String, String>()
        if let token = UserManager.getUserToken() {
            params = ["oauth_token": "\(token)"]
        }
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if var json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    self.info = json["info"] as NSDictionary
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
            }
            }, failure: {(error: NSError) in
                var alert = UIAlertView(title: "Network Error", message: "Error fetching account inoformation!", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Retry")
                
                dispatch_async(dispatch_get_main_queue()) {
                    alert.show()
                }
                
        })
    }
    
    
    // MARK: - TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return info.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell

        if let key = info.allKeys[indexPath.row] as? NSString {
            if let value = info.allValues[indexPath.row] as? NSString {
                cell.textLabel?.text = "\(key): \(value)"
            }
            else if let value = info.allValues[indexPath.row] as? NSDictionary {
                cell.textLabel?.text = key
                cell.accessoryType = .DisclosureIndicator
            }
            else if let value = info.allValues[indexPath.row] as? NSArray {
                let values = value.componentsJoinedByString(", ")
                cell.textLabel?.text = "\(key): \(values)"
            }
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {


    }

}
