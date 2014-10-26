//
//  AccountViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
import SwiftHTTP

class AccountViewController: UITableViewController, UIAlertViewDelegate {
    var account:Account?
    
    func openLogin() {
        AccountStore.deleteAccount()
        navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        let logout = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "openLogin")
        navigationItem.title = "Account"
        navigationItem.rightBarButtonItem = logout
        
        AccountStore.getAccount({ (acct) in
            if acct.token == nil {
                self.openLogin()
            } else {
                self.account = acct
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        })
    
        tableView.rowHeight = 180
        tableView.separatorStyle = .None
        
        var nib = UINib(nibName: "AccountInfoCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "AccountInfoCell")
        
        super.viewWillAppear(animated)
    }


    
    // MARK: - TableView
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> AccountInfoCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountInfoCell", forIndexPath: indexPath) as AccountInfoCell

        print(account?.username)
        
        cell.username?.text = account?.username
        cell.email?.text = account?.mail
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {


    }

}
