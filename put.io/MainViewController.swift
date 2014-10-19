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
        let filesViewController = FilesViewController()
        var filesNavigationController:UINavigationController
        filesNavigationController = UINavigationController(rootViewController: filesViewController)
        filesNavigationController.tabBarItem = filesTabBarItem
        filesViewController.id = 0 // Load root
        filesViewController.navigationItem.title = "Your Files"
        
        
        // Transfers
        let transfersViewController = UIViewController()
        //todo:
        transfersViewController.view = UIView()
        transfersViewController.view.backgroundColor = UIColor.redColor()
        
        var transfersNavigationViewController = UINavigationController(rootViewController: transfersViewController)
        transfersNavigationViewController.tabBarItem = transfersTabBarItem
        transfersViewController.navigationItem.title = "Transfers"
        
        // Account
        let accountViewController = AccountViewController()
        accountViewController.tabBarItem = accountTabBarItem
        
        
        viewControllers = [
            filesNavigationController,
            transfersNavigationViewController,
            accountViewController
        ]

        var token = UserManager.getUserToken()
        
        // if user not logged in
        if (token == nil) {
            selectedIndex = 2
        } else {
            selectedIndex = 0
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
