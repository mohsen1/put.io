//
//  KeyValueTableViewCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/1/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: .Value1, reuseIdentifier:reuseIdentifier)
        textLabel.font = UIFont.systemFontOfSize(14)
        detailTextLabel?.font = UIFont.systemFontOfSize(12)
        userInteractionEnabled = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
