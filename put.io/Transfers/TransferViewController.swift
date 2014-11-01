//
//  TransferViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/31/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit


class TransferViewController: UITableViewController {
    var transfer:NSDictionary?

    override func viewDidLoad() {
        super.viewDidLoad()
        if transfer != nil {
            navigationItem.title = transfer!["name"] as? NSString
        } else {
            navigationItem.title = "Not found!"
        }
    }

    override func viewWillAppear(animated: Bool) {
        var transferInfoCellNib = UINib(nibName: "TransferCell", bundle: nil)

        tableView.registerNib(transferInfoCellNib, forCellReuseIdentifier: "TransferCell")
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        tableView.registerClass(KeyValueTableViewCell.classForCoder(), forCellReuseIdentifier: "KeyValueTableViewCell")
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 2:
                return 24
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

            cell.textLabel.text = "Go to file"
            cell.accessoryType = .DisclosureIndicator

            // Disable Go to file link
            cell.userInteractionEnabled = false
            cell.textLabel.textColor = UIColor.grayColor()

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

}
