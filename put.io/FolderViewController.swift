//
//  FilesViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/18/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class FolderViewController: UITableViewController {
    var files = [File]()
    var id = "0"
    var activityIndicator = UIActivityIndicatorView()
    var progressBarButtton = UIBarButtonItem()
    var refreshBarButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        if self.id == "0" {
            self.navigationItem.title = "Files"
        } else {
            FileStore.getFile(id, { (result:File) in
                self.navigationItem.title = result.name
            })
        }
        refresh(false)
    }

    func refresh(forceFetch: Bool) {
        startProgress()
        FileStore.getFolder(id, forceFetch: forceFetch, { result in
            self.files = result
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
                self.stopProgress()
            }
        })
    }

    func forceRefressh() {
        refresh(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 20, 20))
        self.progressBarButtton = UIBarButtonItem(customView: activityIndicator)
        self.refreshBarButton = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: "forceRefressh")
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        startProgress()
    }

    func startProgress() {
        activityIndicator.startAnimating()
        activityIndicator.activityIndicatorViewStyle = .Gray
        navigationItem.rightBarButtonItem = progressBarButtton
    }

    func stopProgress() {
        navigationItem.rightBarButtonItem = refreshBarButton
    }

    
    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let file = self.files[indexPath.row] as File
        
        cell.textLabel.text = file.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
 
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let file = self.files[indexPath.row] as File

        // if it's a folder drill down navigation
        if file.isFolder {
            let folderViewController = FolderViewController()
            folderViewController.id = file.id

            self.navigationController?.pushViewController(folderViewController, animated: true)
        }
        
        // else, it's a file. open file view controoler
        else {
            let fileViewController = FileViewController()
            fileViewController.file = file
            self.navigationController?.pushViewController(fileViewController, animated: true)
            
        }
    }

}
