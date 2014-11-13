//
//  BinarySettingsCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/12/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class BinarySettingsCell: UITableViewCell {

    @IBOutlet weak var togglerSwitch: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var details: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
