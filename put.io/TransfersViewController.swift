//
//  TransfersViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/21/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class TransfersViewController: UITableViewController, UIAlertViewDelegate {
    var transfers = NSArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        self.fetchList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transfers"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - HTTP
    func fetchList() {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/transfers/list"
        var params = Dictionary<String, String>()
        if let token = UserManager.getUserToken() {
            params = ["oauth_token": "\(token)"]
        }
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    self.transfers = json["transfers"] as NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
            }
            }, failure: {(error: NSError) in
                var alert = UIAlertView(title: "Network Error", message: "Error fetching transfers!", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Retry")
                
                dispatch_async(dispatch_get_main_queue()) {
                    alert.show()
                }
                
        })
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transfers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let transfer:NSDictionary = self.transfers[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = transfer["name"] as NSString
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transfer = self.transfers[indexPath.row] as NSDictionary
    }


}
