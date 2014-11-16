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

        var imageFile = UINib(nibName: "ImageFile", bundle: nil)
        tableView.registerNib(imageFile, forCellReuseIdentifier: "ImageFile")

        var videoFile = UINib(nibName: "VideoFile", bundle: nil)
        tableView.registerNib(videoFile, forCellReuseIdentifier: "VideoFile")

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
        var cell:FileTableViewCell
        if indexPath.row == 0 {
            let type = Types.typeFor(file!.content_type!)
            if type == "Image" {
                cell = tableView.dequeueReusableCellWithIdentifier("ImageFile") as ImageFile
            } else if type == "Video" {
                cell = tableView.dequeueReusableCellWithIdentifier("VideoFile") as VideoFile
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier("PlainFile") as PlainFile
            }
            cell.fill(file!)
            return cell
        }


        // Details
        let detailsCell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        if indexPath.row == 1 { // Name
            detailsCell.textLabel.text = file?.name
            detailsCell.textLabel.lineBreakMode = .ByWordWrapping
            detailsCell.textLabel.numberOfLines = 0
        } else if indexPath.row == 2 { // Size
            detailsCell.textLabel.text = file?.sizeString
        }

        return detailsCell
    }

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }

}
