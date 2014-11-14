//
//  AccountSettingsViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/8/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UITableViewController {
    var account:Account?

    override func viewDidLoad() {
        super.viewDidLoad()

        var binarySettingsCell = UINib(nibName: "BinarySettingsCell", bundle: nil)

        navigationItem.title = "Settings"
        tableView.registerNib(binarySettingsCell, forCellReuseIdentifier: "BinarySettingsCell")
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.rowHeight = 100.0
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       var header = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
       header.backgroundColor = UIColor.clearColor()
       return header
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BinarySettingsCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BinarySettingsCell", forIndexPath: indexPath) as BinarySettingsCell

        if indexPath.row == 0 {
            cell.label.text = "Auto-extract"
            cell.details.text = "If you prefer the extraction checkboxes to be checked by default when you are downloading (or uploading) a compressed file."
            if account != nil {
                cell.togglerSwitch.on = account!.extract
                cell.togglerSwitch.addTarget(self, action: Selector("toggleAutoExtract:"), forControlEvents: .ValueChanged)
            } else {
                cell.togglerSwitch.enabled = false
            }
        } else if indexPath.row == 1 {
            cell.label.text = "Make me invisible"
            cell.details.text = "If you do not want other people to send you friend requests or see you in the sharing tab - unless you are friends."
            if account != nil {
                cell.togglerSwitch.on = account!.invisible
                cell.togglerSwitch.addTarget(self, action: Selector("toggleInvisible:"), forControlEvents: .ValueChanged)
            } else {
                cell.togglerSwitch.enabled = false
            }
//        } else {
//            cell.label.text = "Default Download Folder"
//            cell.details.text = "Your downloads are downloaded into this folder by default."
        }

        return cell
    }

    func toggleAutoExtract(sender: UISwitch) {
        if account != nil {
            account!.extract = !account!.extract
        }
    }
    func toggleInvisible(sender: UISwitch) {
        if account != nil {
            account!.invisible = !account!.invisible
        }
    }
}
