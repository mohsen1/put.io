//
//  FileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FileViewController: UITableViewController {
    var file:File?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")

        var plainFile = UINib(nibName: "PlainFile", bundle: nil)
        tableView.registerNib(plainFile, forCellReuseIdentifier: "PlainFile")


        navigationItem.title = file?.name
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorStyle = .None
        tableView.allowsSelection = false


        super.viewWillAppear(animated)
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        tableView.reloadData()
    }

    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("PlainFile") as PlainFile
            cell.fill(file!)
            return cell
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.row == 1 { // Name
            cell.textLabel.text = file?.name
            cell.textLabel.lineBreakMode = .ByWordWrapping
            cell.textLabel.numberOfLines = 0
        } else if indexPath.row == 2 { // Size
            cell.textLabel.text = file?.sizeString
        }

        return cell
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

}
