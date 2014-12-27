//
//  VideoFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/27/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class VideoFileViewController: FileViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        super.assingDetailsButtonToNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "VideoFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
