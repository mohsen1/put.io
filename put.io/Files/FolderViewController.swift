//
//  FilesViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/18/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FolderViewController: UITableViewController, UIAlertViewDelegate {
    var files = [File]()
    var id:NSNumber = NSNumber(integer: 0)
    var refreshCtrl = UIRefreshControl()
    var activityIndicator: UIActivityIndicatorView?
    var activityIndicatorBarButton: UIBarButtonItem?
    var addButton: UIBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        var folderTableViewCellNib = UINib(nibName: "FolderTableViewCell", bundle: nil)
        tableView.registerNib(folderTableViewCellNib, forCellReuseIdentifier: "FolderTableViewCell")
        tableView.rowHeight = 54
        FileStore.getFile(id, { (result:File) in
            dispatch_async(dispatch_get_main_queue()) {
                self.navigationItem.title = result.name
            }
        })
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicator?.hidden = true
        activityIndicatorBarButton = UIBarButtonItem(customView: activityIndicator!)
        addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: Selector("openNewFolder"))
        navigationItem.rightBarButtonItem = addButton

        refreshCtrl.backgroundColor = UIColor(red:0.97, green:0.97, blue:0.41, alpha:1.0)
        refreshCtrl.addTarget(self, action: Selector("forceRefresh"), forControlEvents: .ValueChanged)
        refreshCtrl.attributedTitle = NSAttributedString(string: "Refreshing")
        refreshControl = refreshCtrl

        // Fetch from local db (forced: true) then force fetch from remote
        doRefresh(silent: true, forced: false)
        doRefresh(silent: true, forced: true)
    }

    func doRefresh(silent: Bool = true, forced: Bool = false) {
        if !silent {
            startProgress()
        }
        FileStore.getFolder(id, forceFetch: forced, { result in
            self.files = result
            dispatch_async(dispatch_get_main_queue()) {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
                if !silent {
                    self.stopProgress()
                }
            }
        })
    }

    func refresh(){
        doRefresh(silent: true)
    }

    func forceRefresh() {
        doRefresh(silent: false)
    }

    func openNewFolder() {
        let alertView = UIAlertView(title: "New Folder", message: "Enter folder name", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alertView.alertViewStyle = .PlainTextInput
        alertView.show()
    }

    func startProgress() {
        navigationItem.rightBarButtonItem = activityIndicatorBarButton
        activityIndicator?.startAnimating()
    }

    func stopProgress() {
        activityIndicator?.stopAnimating()
        navigationItem.rightBarButtonItem = addButton
    }

    func newFolder(name: String) {
        startProgress()
        FileStore.newFolder(name, parentId: id.intValue, completionHandler: { (folder:File?) -> () in
            dispatch_async(dispatch_get_main_queue()) {
                self.refresh()
                self.stopProgress()
            }
        })
    }

    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            let textFiled = alertView.textFieldAtIndex(0)!
            newFolder(textFiled.text)
        }
    }

    // MARK: - TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> FolderTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FolderTableViewCell", forIndexPath: indexPath) as FolderTableViewCell
        let file = self.files[indexPath.row] as File

        cell.fill(file)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let file = self.files[indexPath.row] as File

        navigationController?.pushViewController(fileViewControllerFor(file), animated: true)
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        let file = files[indexPath.row] as File
        startProgress()
        FileStore.deleteFiles([file.id], {_ in
            dispatch_async(dispatch_get_main_queue()) {
                self.stopProgress()
            }
        })
        files.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}
