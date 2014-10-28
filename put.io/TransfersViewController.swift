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
    var activityIndicator = UIActivityIndicatorView()
    var progressBarButtton = UIBarButtonItem()
    var refreshBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "TransferCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TransferCell")
        self.fetchList()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transfers"
        let clean = UIBarButtonItem(title: "Clean", style: .Plain, target: self, action: "clean")
        navigationItem.leftBarButtonItem = clean
        tableView.rowHeight = 60
        
        // Makae Navigation Bar buttons 
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
        self.progressBarButtton = UIBarButtonItem(customView: activityIndicator)
        self.refreshBarButton = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "fetchList")
        
        startProgress()
    }
    
    func startProgress() {
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .Gray
        navigationItem.rightBarButtonItem = progressBarButtton
    }
    
    func stopProgress() {
        navigationItem.rightBarButtonItem = refreshBarButton
    }

    // MARK: - HTTP
    func clean() {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/transfers/clean"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access transfers")
        }

        startProgress()
        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            self.fetchList()
            self.startProgress()
        }, failure: {(error: NSError, response: HTTPResponse?) in
            print(error)
            self.startProgress()
        })
    }

    func fetchList() {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/transfers/list"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access transfers")
        }
        
        self.startProgress()
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    self.transfers = json["transfers"] as NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                        self.stopProgress()
                        self.tableView.reloadData()
                    }
                }
            }
            }, failure: {(error: NSError, response: HTTPResponse?) in
                var alert = UIAlertView(title: "Network Error", message: "Error fetching transfers!", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Retry")
                
                dispatch_async(dispatch_get_main_queue()) {
                    alert.show()
                    self.stopProgress()
                }
                
        })
    }
    
    // MARK: - TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transfers.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TransferCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransferCell", forIndexPath: indexPath) as TransferCell
        let transfer:NSDictionary = self.transfers[indexPath.row] as NSDictionary
        
        if let percentage = transfer["percent_done"] as NSInteger? {
            cell.percentage?.text = "%\(percentage)"
            cell.progress?.progress = (Float(percentage) / 100)
        }
        cell.title?.text = transfer["name"] as NSString
        

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transfer = self.transfers[indexPath.row] as NSDictionary
    }


}
