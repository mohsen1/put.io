//
//  NSDate.swift
//  put.io
//
//  Created by Mohsen Azimi on 1/6/15.
//  Copyright (c) 2015 Mohsen Azimi. All rights reserved.
//

import Foundation

func <=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
}
func >=(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
}
func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
}
func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
}
func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
}