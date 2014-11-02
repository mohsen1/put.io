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
    var refreshCtrl = UIRefreshControl()
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "TransferCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TransferCell")
        self.fetchList(false)
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("fetchListSilent"), userInfo: nil, repeats: true)

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transfers"
        let clean = UIBarButtonItem(title: "Clean", style: .Plain, target: self, action: "clean")
        navigationItem.leftBarButtonItem = clean
        tableView.rowHeight = 50

        // Make Navigation Bar buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("fetchListSilent"))
        
        refreshCtrl.backgroundColor = UIColor.blueColor()
        refreshCtrl.addTarget(self, action: Selector("fetchListLaud"), forControlEvents: .ValueChanged)
        refreshCtrl.attributedTitle = NSAttributedString(string: "TESTSSTSTSTT")
        refreshControl = refreshCtrl
        timer.fire()
        fetchListLaud()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer.invalidate()
    }



    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 {
            self.timer.invalidate()
        } else {
            self.fetchListLaud()
        }
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

        request.POST(url, parameters: params, success: {(response: HTTPResponse) in
            self.fetchListLaud()
        }, failure: {(error: NSError, response: HTTPResponse?) in
            print(error)
            self.refreshCtrl.endRefreshing()
        })
    }

    func fetchList(silent: Bool) {
        let request = HTTPTask()
        let url = "https://api.put.io/v2/transfers/list"
        var params = [String:String]()
        if let account = AccountStore.getAccountSync() {
            params = ["oauth_token": "\(account.token!)"]
        } else {
            print("Not logged in, trying to access transfers")
        }


        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    self.transfers = json["transfers"] as NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                        self.refreshCtrl.endRefreshing()
                    }
                }
            }
            }, failure: {(error: NSError, response: HTTPResponse?) in
                var alert = UIAlertView(title: "Network Error", message: "Error fetching transfers!", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Retry")

                dispatch_async(dispatch_get_main_queue()) {
                    alert.show()
                    self.timer.invalidate()
                    self.refreshCtrl.endRefreshing()
                }

        })
    }

    func fetchListSilent() {
        fetchList(true)
    }

    func fetchListLaud() {
        fetchList(false)
    }

    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transfers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TransferCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransferCell", forIndexPath: indexPath) as TransferCell
        if let transfer:NSDictionary = self.transfers[indexPath.row] as? NSDictionary {
            cell.load(transfer);
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transfer = self.transfers[indexPath.row] as NSDictionary
        let transferViewController = TransferViewController()

        transferViewController.transfer = transfer
        navigationController?.pushViewController(transferViewController, animated: true)
    }
}
