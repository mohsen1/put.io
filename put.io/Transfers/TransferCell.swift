//
//  TransferCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/21/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class TransferCell: UITableViewCell {

    @IBOutlet weak var estimateTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var percentage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    internal func load(transfer: NSDictionary){
        if let secs = transfer.objectForKey("estimated_time") as? Int {
            estimateTime.text = Util.formatEstimateTime(secs)
        }
        if let percent = transfer["percent_done"] as? NSInteger {
            percentage.text = "\(percent)%"
            drawPercentage(Float(percent), status: transfer["status"]! as String)
            if percent == 100 {
                estimateTime.text = ""
            }
        }
        title.text = transfer["name"] as NSString
    }

    internal func drawPercentage(percentage: Float, status: String){
        var width = (contentView.bounds.width * CGFloat(percentage)) / 100.0
        var rect = CGRectMake(0, 0, width, contentView.bounds.height)
        var percentageView = UIView(frame: rect)

        if status == "WAITING" {
            percentageView.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.35, alpha: 1)
        }
        else {
            percentageView.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.85, alpha: 1)
        }

        contentView.insertSubview(percentageView, atIndex: 0)
    }
}
