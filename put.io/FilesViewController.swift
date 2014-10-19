//
//  FilesViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/18/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class FilesViewController: UITableViewController, UIAlertViewDelegate {

    var files = NSArray()
    var id:NSNumber?
    var token:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - HTTP
    func fetchList(id:NSNumber) {
        var request = HTTPTask()
        var url = "https://api.put.io/v2/files/list"
        var params = [
            "oauth_token": "\(self.token!)",
            "parent_id": "\(id)"
        ]
        
        request.GET(url, parameters: params, success: {(response: HTTPResponse) in
            if let data = response.responseObject as? NSData {
                var jsonError:NSError?
                if let json:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &jsonError) as? NSDictionary {
                    self.files = json["files"] as NSArray
                    dispatch_async(dispatch_get_main_queue()) {
                        self.tableView.reloadData()
                    }
                }
            }
            }, failure: {(error: NSError) in
                var alert = UIAlertView(title: "Network Error", message: "Error fetching your files!", delegate: self, cancelButtonTitle: "OK", otherButtonTitles: "Retry")

                dispatch_async(dispatch_get_main_queue()) {
                    alert.show()
                }

        })
    }

    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            self.fetchList(self.id!)
        }
    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let file:NSDictionary = self.files[indexPath.row] as NSDictionary
        
        cell.textLabel?.text = file["name"] as NSString
 
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let file = self.files[indexPath.row] as NSDictionary
        let fileIcon = file["icon"] as? String

        // if it's a folder drill down navigation
        if fileIcon!.rangeOfString("folder.png", options: nil) != nil {
            let filesViewController:FilesViewController = FilesViewController()
            filesViewController.id = file["id"] as? NSNumber
            filesViewController.navigationItem.title = file["name"] as? NSString

            self.navigationController?.pushViewController(filesViewController, animated: true)
        }
        
        // else, it's a file. open file view controoler
        else {
            let fileViewController = FileViewController()
            fileViewController.file = file
            self.navigationController?.pushViewController(fileViewController, animated: true)
            
        }
    }

}
