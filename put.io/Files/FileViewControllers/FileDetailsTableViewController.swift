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
        return 3
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailsTabeViewCell", forIndexPath: indexPath) as UITableViewCell
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Name"
            cell.detailTextLabel?.text = file?.name
            break
        case 1:
            cell.textLabel?.text = "Accessed at"
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(file!.first_accessed_at!)
        case 2:
            cell.textLabel?.text = "MP4 available"
            if let yes = file?.is_mp4_available {
                cell.detailTextLabel?.text = file!.is_mp4_available! == 0 ? "No" : "Yes"
            } else {
                cell.detailTextLabel?.text = "No"
            }
        default:
            break
        }
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.sizeToFit()
        
        return cell
    }

    
//    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCellWithIdentifier("DetailsTabeViewCell", forIndexPath: indexPath) as UITableViewCell
//        let frame = cell.frame
//        
//    }
//    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
