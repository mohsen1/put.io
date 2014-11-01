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
                switch indexPath.row {


                case 0:
                    cell.textLabel.text = "Name"
                    cell.detailTextLabel?.text = transfer!["name"] as? String

                case 1:
                    cell.textLabel.text = "Size"
                    cell.detailTextLabel?.text = transfer!["size"] as? String

                case 2:
                    // finished_at
                    cell.textLabel.text = "Estimated time"
                    cell.detailTextLabel?.text = transfer!["estimated_time"] as? String

                case 3:
                    cell.textLabel.text = "Availability"
                    if let av = transfer!["availability"] as? NSInteger {
                        cell.detailTextLabel?.text = "\(av)%"
                    }

                case 4:
                    cell.textLabel.text = "Percentage done"
                    if let pd = transfer!["percent_done"] as? NSInteger {
                        cell.detailTextLabel?.text = "\(pd)%"
                    }

                case 5:
                    cell.textLabel.text = "Download Speed"
                    if let speed = transfer!["down_speed"] as? NSInteger {
                        cell.detailTextLabel?.text = "\(speed)"
                    }

                case 6:
                    cell.textLabel.text = "Upload Speed"
                    if let speed = transfer!["down_speed"] as? NSInteger {
                        cell.detailTextLabel?.text = "\(speed)"
                    }

                case 7:
                    cell.textLabel.text = "Downloaded"
                    cell.detailTextLabel?.text = transfer!["downloaded"] as? String

                case 8:
                    cell.textLabel.text = "Uploaded"
                    cell.detailTextLabel?.text = transfer!["uploaded"] as? String

                case 9:
                    cell.textLabel.text = "Ratio"
                    cell.detailTextLabel?.text = transfer!["current_ratio"] as? String

                case 10:
                    cell.textLabel.text = "Callback URL"
                    cell.detailTextLabel?.text = transfer!["callback_url"] as? String
                case 11:
                    cell.textLabel.text = "Created at"
                    cell.detailTextLabel?.text = (transfer!["created_at"] as? String) // TODO: date format

                case 12:
                    cell.textLabel.text = "Error"
                    cell.detailTextLabel?.text = transfer!["error_message"] as? String
                    cell.detailTextLabel?.textColor = UIColor.redColor()

                case 13:
                    cell.textLabel.text = "Magnet link"
                    cell.detailTextLabel?.text = transfer!["magneturi"] as? String


                case 14:
                    cell.textLabel.text = "Connected peers"
                    cell.detailTextLabel?.text = transfer!["peers_connected"] as? String

                case 15:
                    cell.textLabel.text = "Peers getting from us"
                    cell.detailTextLabel?.text = transfer!["peers_getting_from_us"] as? String

                case 16:
                    cell.textLabel.text = "Peers sending to us"
                    cell.detailTextLabel?.text = transfer!["peers_getting_from_us"] as? String

                case 17:
                    cell.textLabel.text = "Seeding for"
                    cell.detailTextLabel?.text = transfer!["seconds_seeding"] as? String // Date

                case 18:
                    cell.textLabel.text = "Downloading to folder"
                    cell.detailTextLabel?.text = transfer!["save_parent_id"] as? String // File...

                case 19:
                    cell.textLabel.text = "Status"
                    cell.detailTextLabel?.text = transfer!["status"] as? String

                case 20:
                    cell.textLabel.text = "Type"
                    cell.detailTextLabel?.text = transfer!["type"] as? String

                case 21:
                    cell.textLabel.text = "Private"
                    cell.detailTextLabel?.text = transfer!["is_privat"] as? String

                case 22:
                    cell.textLabel.text = "Source"
                    cell.detailTextLabel?.text = transfer!["source"] as? String  //Copy

                case 23:
                    cell.textLabel.text = "Trackers"
                    if let trackets = transfer!["trackers"] as? NSArray {
                        var str = ""
                        for tracker in trackets {
                            if let ts = tracker as? String  {
                                str += ts
                            }
                        }
                        cell.detailTextLabel?.text = str
                    }



                default:
                    cell.textLabel.text = "TODO!"
                    cell.detailTextLabel?.text = "!!!!!"
                }
            }
            return cell
        default:
            return tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        }
    }

}
