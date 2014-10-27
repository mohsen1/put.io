//
//  AccountInfoCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/25/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AccountInfoCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var storage: UILabel!
    @IBOutlet weak var email: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
    private func toGB(size:Double) -> Int {
        let gb = size / (1024 * 1024 * 1024)
        return Int(gb)
    }
    
    internal func loadAccount(account:Account?){
            
        username?.text = account?.username
        email?.text = account?.mail
        let avail = account?.disk_avail
        let size = account?.disk_size
        storage?.text = "\(toGB(avail!))GB available of \(toGB(size!))GB"
    }
}
