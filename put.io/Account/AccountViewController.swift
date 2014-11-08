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

        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor(white: 1, alpha: 0.95)

        var accountInfoCellNib = UINib(nibName: "AccountInfoCell", bundle: nil)
        tableView.registerNib(accountInfoCellNib, forCellReuseIdentifier: "AccountInfoCell")
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "UITableViewCell")

        super.viewWillAppear(animated)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let acct = AccountStore.getAccountSync() {
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
    }

    // MARK: - TableView
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }

   override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       var header = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
       header.backgroundColor = UIColor.clearColor()
       return header
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

    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 { // Settings
            let settingsViewController = AccountSettingsViewController()
            navigationController?.pushViewController(settingsViewController, animated: true)
        }
    }
}
