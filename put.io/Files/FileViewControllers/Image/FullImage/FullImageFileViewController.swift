//
//  FullImageFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/28/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

@IBDesignable class FullImageFileViewController: FileViewController {
    var url:NSURL!
    var navigationBarBackgroundImage:UIImage!
    var navigationBarShadowImage:UIImage!
    
    @IBOutlet weak var showNavButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.hidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)
        navigationBarShadowImage = navigationController?.navigationBar.shadowImage
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
    }

    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "FullImageFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    @IBAction func showNav(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController!.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: true)
            return
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = navigationBarShadowImage
        navigationController?.navigationBar.translucent = true
    }

}
