//
//  FilesViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/18/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class FolderViewController: UITableViewController, UIAlertViewDelegate {

    var files = [File]()
    var id:Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
//        
//        FileStore.getFolder(id!, { result in
//            self.files = result
//            dispatch_async(dispatch_get_main_queue()) {
//                self.tableView.reloadData()
//            }
//        })
        
        if id == 0 {
            self.navigationItem.title = "Files"
        } else {
            FileStore.getFile(id!, { (result:File) in
                self.navigationItem.title = result.name
            })
        }
    }

    
//    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
//        if buttonIndex == 1 {
//            self.fetchList(self.id!)
//        }
//    }
    
    // MARK: - TableView

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.files.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
        let file = self.files[indexPath.row] as File
        
        cell.textLabel.text = file.name
 
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
