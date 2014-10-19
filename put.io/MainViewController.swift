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
        let filesViewController = FilesViewController()
        var navigationController:UINavigationController
        navigationController = UINavigationController(rootViewController: filesViewController)
        navigationController.tabBarItem = filesTabBarItem
        filesViewController.id = 0 // Load root
        filesViewController.navigationItem.title = "Your Files"
        viewControllers = [navigationController]
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
