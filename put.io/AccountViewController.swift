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
    
    func openLogin(animated:Bool = true) {
        let appDomain = NSBundle.mainBundle().bundleIdentifier
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)
        let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        for cookie in cookies.cookies! {
            cookies.deleteCookie(cookie as NSHTTPCookie)
        }

        AccountStore.deleteAccount()
        navigationController?.pushViewController(LoginViewController(), animated: animated)
    }
    
    func openLoginAnimated(){
        openLogin(animated: true)
    }
    
    // MARK: View
    override func viewWillAppear(animated: Bool) {
        let logout = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "openLoginAnimated")
        navigationItem.title = "Account"
        navigationItem.rightBarButtonItem = logout
        
        if let acct = AccountStore.getAccountSync() {
            println("account token after getting accountSync in accountvc is \(acct.token)")
            if acct.token == nil {
                self.openLogin(animated: false)
            } else {
                self.account = acct
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
            }
        } else {
            self.openLogin(animated: false)
        }
    
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.95)
        
        var accountInfoCellNib = UINib(nibName: "AccountInfoCell", bundle: nil)

        tableView.registerNib(accountInfoCellNib, forCellReuseIdentifier: "AccountInfoCell")
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")
        
        super.viewWillAppear(animated)
    }

    // MARK: - TableView
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func  tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 180.0
        }
        return 40.0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel.text = "Settings"
            cell.accessoryType = .DisclosureIndicator
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AccountInfoCell", forIndexPath: indexPath) as AccountInfoCell
        cell.loadAccount(account)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
