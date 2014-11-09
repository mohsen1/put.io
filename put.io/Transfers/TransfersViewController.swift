//
//  TransfersViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/21/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit


class TransfersViewController: UITableViewController, UIAlertViewDelegate {
    var transfers = [Transfer]()
    var refreshCtrl = UIRefreshControl()
    var progressBarButtton = UIBarButtonItem()
    var cleanBtn = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "TransferCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TransferCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transfers"

        cleanBtn = UIBarButtonItem(title: "Clean up", style: .Plain, target: self, action: "clean")

        let activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
        progressBarButtton = UIBarButtonItem(customView: activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .Gray
        navigationItem.leftBarButtonItem = progressBarButtton
        tableView.rowHeight = 50
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("openAdd"))

        refreshCtrl.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.41, alpha:1.0)
        refreshCtrl.addTarget(self, action: Selector("fetch"), forControlEvents: .ValueChanged)
        refreshCtrl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl = refreshCtrl
        fetch()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Store Manager
    func fetch() {
        TransferStore.getAll({ (results:[Transfer]) in
            self.transfers = results
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.navigationItem.leftBarButtonItem = self.cleanBtn
            }
        })
    }

    func clean() {
        navigationItem.leftBarButtonItem = progressBarButtton
        TransferStore.clean({ (error:NSError?) in
            if error == nil {
                self.fetch()
            } else {
                self.navigationItem.leftBarButtonItem = self.cleanBtn
            }
        })
    }
    
    func openAdd() {
        let add = AddTransferViewController(nibName: "AddTransferViewController", bundle: nil)
        self.presentViewController(add, animated: true, completion: {})
    }

    // MARK: - TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transfers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TransferCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransferCell", forIndexPath: indexPath) as TransferCell
        cell.load(transfers[indexPath.row]);

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transferViewController = TransferViewController()

        transferViewController.transfer = transfers[indexPath.row]
        navigationController?.pushViewController(transferViewController, animated: true)
    }
}
