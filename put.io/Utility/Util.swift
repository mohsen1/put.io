//
//  File.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/1/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import Foundation

public class Util {
    class func formatEstimateTime(secs:Int) -> String {
        let MINUTE = 60
        let HOUR = 60 * MINUTE
        let DAY = 24 * HOUR
        let WEEK = 7 * DAY
        let MONTH = 30 * DAY
        if secs == -1 {
            return "∞"
        }
        if secs > MONTH {
            return "\(secs/MONTH) months"
        }
        if secs > WEEK {
            let days = (secs % WEEK) / DAY
            return "\(secs / WEEK) weeks and \(days) days"
        }
        if secs > DAY {
            let hours = (secs % DAY) / HOUR
            return "\(secs/DAY) days and \(hours) hours"
        }
        if secs > HOUR {
            let minutes = (secs % HOUR) / MINUTE
            return "\(secs/HOUR) hours and \(minutes) minutes"
        }
        if secs > MINUTE {
            let seconds = secs % MINUTE
            return "\(secs / MINUTE) minutes and \(seconds) seconds"
        }
        return "\(secs) seconds"
    }
}