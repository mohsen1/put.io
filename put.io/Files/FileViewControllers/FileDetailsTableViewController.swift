//
//  FileDetailsTableViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/30/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit


class DetailsTabeViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Value1, reuseIdentifier: reuseIdentifier)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class FileDetailsTableViewController: UITableViewController {
    var file:File?
    private let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Details"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("close"))
        tableView.registerClass(DetailsTabeViewCell.classForCoder(), forCellReuseIdentifier: "DetailsTabeViewCell")
        tableView.allowsSelection = false
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: {})
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailsTabeViewCell", forIndexPath: indexPath) as UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = file?.name
            break
        case 1:
            cell.textLabel?.text = "Accessed"
            if let accessed = file?.first_accessed_at? {
                cell.detailTextLabel?.text = dateFormatter.stringFromDate(accessed)
            } else {
                cell.detailTextLabel?.text = "Never"
            }
        case 2:
            cell.textLabel?.text = "MP4 available"
            if let yes = file?.is_mp4_available {
                cell.detailTextLabel?.text = file!.is_mp4_available! == 0 ? "No" : "Yes"
            } else {
                cell.detailTextLabel?.text = "No"
            }
        case 3:
            cell.textLabel?.text = "Size"
            cell.detailTextLabel?.text = file?.sizeString
        default:
            break
        }
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.sizeToFit()
        
        return cell
    }
}
