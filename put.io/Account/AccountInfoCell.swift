//
//  AccountInfoCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/25/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AccountInfoCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var storage: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var subtitleLang: UILabel!
    @IBOutlet weak var expires: UILabel!
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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        if account != nil {
            let avail = toGB(account!.disk_avail)
            let size = toGB(account!.disk_size)
            let date = dateFormatter.stringFromDate(account!.plan_expiration_date!)
            username?.text = account?.username
            email?.text = account?.mail
            storage?.text = "\(avail)GB available of \(size)GB"
            subtitleLang?.text = "Default subtitle language: \(account!.default_subtitle_language!)"
            expires?.text = "Plan expires at \(date)"
        
                if let imageUrl = NSURL(string: account!.avatar_url) {
                    if let imageData = NSData(contentsOfURL: imageUrl) {
                        avatarImage.image = UIImage(data: imageData)
                    }
                }
        }
    }
}
