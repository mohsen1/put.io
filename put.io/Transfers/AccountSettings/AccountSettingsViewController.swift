//
//  AccountSettingsViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/8/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        var binarySettingCell = UINib(nibName: "BinarySettingCell", bundle: nil)
        tableView.registerNib(binarySettingCell, forCellReuseIdentifier: "BinarySettingCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BinarySettingCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BinarySettingCell", forIndexPath: indexPath) as BinarySettingCell
        
        cell.textLabel.text = "Binrary setting"

        return cell
    }
}
