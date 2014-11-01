//
//  TransferViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/31/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class TransferViewController: UITableViewController, UIAlertViewDelegate {
    var transfer:NSDictionary?
    var activityIndicator = UIActivityIndicatorView()
    var progressBarButtton = UIBarButtonItem()
    var refreshBarButton = UIBarButtonItem()
    var timer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        if transfer != nil {
            navigationItem.title = transfer!["name"] as? NSString
        } else {
            navigationItem.title = "Not found!"
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("refreshSilent"), userInfo: nil, repeats: true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        var transferInfoCellNib = UINib(nibName: "TransferCell", bundle: nil)

        tableView.registerNib(transferInfoCellNib, forCellReuseIdentifier: "TransferCell")
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.registerClass(KeyValueTableViewCell.classForCoder(), forCellReuseIdentifier: "KeyValueTableViewCell")


        // Make Navigation Bar buttons
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
        progressBarButtton = UIBarButtonItem(customView: activityIndicator)
        refreshBarButton = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "refreshLoad")
        navigationItem.rightBarButtonItem = refreshBarButton
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 2:
                return 24
            case 1:
                return 2
            default:
                return 1
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return " "
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("TransferCell", forIndexPath: indexPath) as TransferCell

            cell.userInteractionEnabled = false

            if transfer != nil {
                cell.load(transfer!)
            }

            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell

            if indexPath.row == 0 {
                cell.textLabel.text = "Go to file"
                cell.accessoryType = .DisclosureIndicator

                // Disable Go to file link for now
                cell.userInteractionEnabled = false
                cell.textLabel.textColor = UIColor.grayColor()
            } else {
                // Disabled cancel button by default
                cell.accessoryType = .DisclosureIndicator
                cell.textLabel.text = "Cancel this transfer"
                cell.userInteractionEnabled = false
                cell.textLabel.textColor = UIColor.grayColor()

                if transfer != nil {
                    if let status = transfer!["status"]! as? String {
                        if status != "COMPLETED" {
                            cell.userInteractionEnabled = true
                            cell.textLabel.textColor = UIColor.redColor()
                        }
                    }
                }
            }

            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("KeyValueTableViewCell", forIndexPath: indexPath) as KeyValueTableViewCell

            if transfer != nil {
                cell.setValue(indexPath.row, tr: transfer!)
            }

            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.section == 1 && indexPath.row == 1 {
            if let status = transfer!["status"]! as? String {
                if status == "DOWNLOADING" {
                    let alert = UIAlertView(title: "Do you want to coancel this transfer?", message: "", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Yes")
                    alert.show()
                } else {
                    // TODO clean
                }
            }

        }

    }

    // MARK: - Alert view
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 { // Yes
            if let transferId = transfer!["id"] as? NSInteger {
                let request = HTTPTask()
                let account = AccountStore.getAccountSync()
                let url = "https://api.put.io/v2/transfers/cancel"
                var params: Dictionary<String, String> = [
                    "transfer_ids": "\(transferId)",
                    "access_token": "\(account!.token!)"
                ]

                navigationController?.popToRootViewControllerAnimated(true)

                request.POST(url, parameters: params, success: {(response: HTTPResponse) in
                }, failure: {(error: NSError, response: HTTPResponse?) in
                    print(error)
                })
            }
        }
    }

    func startProgress() {
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .Gray
        navigationItem.rightBarButtonItem = progressBarButtton
    }

    func stopProgress() {
        navigationItem.rightBarButtonItem = refreshBarButton
    }

    func refreshLoad() {
        refresh(silent: false)
    }

    func refreshSilent(){ refresh() }

    func refresh (silent: Bool = true) {
        if transfer != nil {
            if let transferId = transfer!["id"] as? NSInteger {
                let request = HTTPTask()
                let account = AccountStore.getAccountSync()
                let url = "https://api.put.io/v2/transfers/\(transferId)"
                var params: Dictionary<String, String> = [
                    "access_token": "\(account!.token!)"
                ]

                if !silent { startProgress() }
                request.GET(url, parameters: params, success: {(response: HTTPResponse) in
                    if let data = response.responseObject as? NSData {
                        var jsonError:NSError?
                        if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                            if let newTeansfer = json["transfer"] as? NSDictionary {
                                self.transfer = newTeansfer
                                dispatch_async(dispatch_get_main_queue()) {
                                    self.stopProgress()
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                    self.stopProgress()
                    }, failure: {(error: NSError, response: HTTPResponse?) in
                        print(error)
                        self.stopProgress()
                })
            }

        }
    }
}
