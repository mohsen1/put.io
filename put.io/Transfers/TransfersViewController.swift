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
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "TransferCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "TransferCell")
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("fetch"), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Transfers"

        let cleanBtn = UIBarButtonItem(title: "Clean up", style: .Plain, target: self, action: "clean")
        navigationItem.leftBarButtonItem = cleanBtn

        tableView.rowHeight = 50

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("fetch"))

        refreshCtrl.backgroundColor = UIColor.blueColor()
        refreshCtrl.addTarget(self, action: Selector("fetch"), forControlEvents: .ValueChanged)
        refreshCtrl.attributedTitle = NSAttributedString(string: "TESTSSTSTSTT")
        refreshControl = refreshCtrl
        timer.fire()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    // MARK: - Store Manager
    func fetch() {
        refreshControl?.beginRefreshing()
        TransferStore.getAll({ (results:[Transfer]) in
            self.transfers = results
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        })
    }

    func clean() {
        refreshControl?.beginRefreshing()
        TransferStore.clean({ (error:NSError?) in
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        })
    }

    // MARK: - TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transfers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> TransferCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TransferCell", forIndexPath: indexPath) as TransferCell
        cell.load(self.transfers[indexPath.row]);

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let transfer = self.transfers[indexPath.row] as NSDictionary
//        let transferViewController = TransferViewController()
//
//        transferViewController.transfer = transfer
//        navigationController?.pushViewController(transferViewController, animated: true)
    }
}
