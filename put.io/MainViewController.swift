//
//  MainViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/19/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        let fileTabBarIcon = UIImage(named: "FilesTabBarIcon")
        let filesTabBarItem = UITabBarItem(title: "Files", image: fileTabBarIcon, tag: 0)
        let transfersTabBarIcon = UIImage(named: "TransfersTabBarIcon")
        let transfersTabBarItem = UITabBarItem(title: "Transfers", image: transfersTabBarIcon, tag: 1)
        let accountTabBarIcon = UIImage(named: "AccountTabBarIcon")
        let accountTabBarItem = UITabBarItem(title: "Account", image: accountTabBarIcon, tag: 2)
        
        // Files
        let folderViewController = FolderViewController()
        var filesNavigationController = UINavigationController(rootViewController: folderViewController)
        filesNavigationController.tabBarItem = filesTabBarItem
        
        
        // Transfers
        let transfersViewController = TransfersViewController()
        var transfersNavigationController = UINavigationController(rootViewController: transfersViewController)
        transfersNavigationController.tabBarItem = transfersTabBarItem

        
        // Account
        let accountViewController = AccountViewController()
        let accountNavigationViewController = UINavigationController(rootViewController: accountViewController)
        accountNavigationViewController.tabBarItem = accountTabBarItem
        
        
        viewControllers = [
            filesNavigationController,
            transfersNavigationController,
            accountNavigationViewController
        ]
        
        // if user not logged in go to inxex 2 (Account) else go to index 0 (Files)
        if let account = AccountStore.getAccountSync(){
            if account.token == nil {
                println("token is nil")
                selectedIndex = 2
            } else {
                selectedIndex = 0
            }
        } else {
            println("account is nil")
            selectedIndex = 2
        }
    }

}
