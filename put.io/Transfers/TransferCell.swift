//
//  TransferCell.swift
//  put.io
//
//  Created by Mohsen Azimi on 10/21/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

let MINUTE = 60
let HOUR = 60 * MINUTE
let DAY = 24 * HOUR
let WEEK = 7 * DAY
let MONTH = 30 * DAY

func formatEstimateTime(secs:Int) -> String {
    if secs == -1 {
        return "∞"
    }
    if secs > MONTH {
        return "\(secs/MONTH) months"
    }
    if secs > WEEK {
        let days = (secs % WEEK) / DAY
        return "\(secs / WEEK) weeks \(days) days"
    }
    if secs > DAY {
        let hours = (secs % DAY) / HOUR
        return "\(secs/DAY) days \(hours) hours"
    }
    if secs > HOUR {
        let minutes = (secs % HOUR) / MINUTE
        return "\(secs/HOUR) hours \(minutes) minutes"
    }
    if secs > MINUTE {
        let seconds = secs % MINUTE
        return "\(secs / MINUTE) minutes \(seconds) seconds"
    }
    return "\(secs) seconds"
}


class TransferCell: UITableViewCell {

    @IBOutlet weak var estimateTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var percentage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    internal func load(transfer: NSDictionary){
        if let secs = transfer.objectForKey("estimated_time") as? Int {
            estimateTime.text = formatEstimateTime(secs)
        }
        if let percent = transfer["percent_done"] as? NSInteger {
            percentage.text = "\(percent)%"
            drawPercentage(Float(percent))
            if percent == 100 {
                estimateTime.text = ""
            }
        }
        title.text = transfer["name"] as NSString
    }
    
    internal func drawPercentage(percentage: Float){
        let width = self.contentView.bounds.width * CGFloat(percentage) / 100.0
        var rect = CGRectMake(0, 0, width, self.contentView.bounds.height)
        var percentage = UIView(frame: rect)
        percentage.backgroundColor = UIColor(red: 0.8, green: 1.0, blue: 0.85, alpha: 1)
        self.contentView.insertSubview(percentage, atIndex: 0)
    }
}
