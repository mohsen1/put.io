//
//  FileTableViewCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/15/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit


// Just the protocol
class FileTableViewCell: UITableViewCell {
    var file:File?

    internal func fill(file:File) {
      self.file = file
    }
}
