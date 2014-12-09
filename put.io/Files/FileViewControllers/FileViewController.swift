//
//  FileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/30/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FileViewController: UIViewController {
    var file:File?
    
    func openDetailsViewController() {
        let nav = UINavigationController()
        let details = FileDetailsTableViewController()
        
        details.file = file
        nav.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        nav.pushViewController(details, animated: false)
        presentViewController(nav, animated: true, completion: {})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = file?.name
    }
}

internal func fileViewControllerFor(file:File) -> UIViewController {
    let type = Types.typeFor(file.content_type!)
    var vc:FileViewController!

    switch type {
    case .FOLDER:
        let vc = FolderViewController()
        vc.id = file.id
        return vc
    case .IMAGE:
        vc = ImageFileViewController()
    case .TEXT, .PDF:
        vc = WebViewFileViewController()
    default:
        vc = PlainFileViewController()
    }

    vc.file = file
    return vc
}