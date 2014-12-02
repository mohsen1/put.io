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
        nav.pushViewController(FileDetailsTableViewController(), animated: false)
        presentViewController(nav, animated: true, completion: {})
    }
}

internal func fileViewControllerFor(file:File) -> UIViewController {
    let type = Types.typeFor(file.content_type!)

    switch type {
    case .AUDIO:
        println("Audio!")
        break
    case .VIDEO:
        println("Video!")
        break
    case .IMAGE:
        println("Image!")
        break
    case .FOLDER:
        let vc = FolderViewController()
        vc.id = file.id
        return vc
    default:
        break
    }

    let vc = PlainFileViewController()
    vc.file = file
    return vc
}