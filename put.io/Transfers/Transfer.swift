//
//  Transfer.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/1/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import Foundation


class Transfer {
    private let byteFormatter = NSByteCountFormatter()
    private var dateFormatter = NSDateFormatter()
    private var mediumDateFormatter = NSDateFormatter()

    var id: Int64                   = -1
    var name: String                = "Unknown"
    var size: Int64                 = 0
    var sizeString: String          = ""
    var magnetUri: String           = "N/A"
    var estimatedTime: Int64        = 0
    var estimatedTimeString: String = ""
    var availability: Int64         = 0
    var availabilityString: String  = "N/A"
    var percentDone: Int64          = 0
    var percentDoneString: String   = "N/A"
    var downloadSpeed: Int64        = 0
    var downloadSpeedString: String = "N/A"
    var uploadSpeed: Int64          = 0
    var updoadSpeedString: String   = "N/A"
    var downloaded: Int64           = 0
    var downloadedString: String    = "N/A"
    var uploaded: Int64             = 0
    var uploadedString: String      = "N/A"
    var ratio: String               = "N/A"
    var createdAt: NSDate?          = nil
    var createdAtString: String     = "N/A"
    var error: String               = "No error"
    var peersConnceted: Int64       = 0
    var peersGettingFromUs: Int64   = 0
    var peersSendingToUs: Int64     = 0
    var seedingFor: Int64           = 0
    var seedingForString: String    = "N/A"
    var status: String              = ""
    var type: String                = ""
    var source: String              = ""
    var isPrivate: Bool             = false
    var trackers: NSArray           = NSArray()
    var trackersString: String      = ""
    var saveParentId: Int64         = 0
    var fileId: Int64               = 0
    var saveParent: File?
    var file: File?

    init (json:NSDictionary) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        mediumDateFormatter.dateStyle = .MediumStyle
        mediumDateFormatter.timeStyle = .MediumStyle

        if let _id = json["id"] as? NSNumber {
            id = _id.longLongValue
        }
        
        if let _name = json["name"] as? String {
            name = _name
        }

        if let _size = json["size"] as? NSNumber {
            size = _size.longLongValue
            sizeString = byteFormatter.stringFromByteCount(size)
        }

        if let _magnetUri = json["magnetUri"] as? String {
            magnetUri = _magnetUri
        }

        if let _estimatedTime = json["estimated_time"] as? NSInteger {
            estimatedTimeString = Util.formatEstimateTime(Int(_estimatedTime))
            estimatedTime = Int64(_estimatedTime)
        }

        if let av = json["availability"] as? NSInteger {
            availabilityString = "\(av)%"
            availability = Int64(av)
        }

        if let pd = json["percent_done"] as? NSInteger {
            availabilityString = "\(pd)%"
            availability = Int64(pd)
        }

        if let speed = json["down_speed"] as? NSNumber {
            downloadSpeed = speed.longLongValue
            let formatted = byteFormatter.stringFromByteCount(downloadSpeed)
            downloadSpeedString = "\(formatted)/s"
        }

        if let speed = json["up_speed"] as? NSNumber {
            uploadSpeed = speed.longLongValue
            let formatted = byteFormatter.stringFromByteCount(uploadSpeed)
            updoadSpeedString = "\(formatted)/s"
        }

        if let value = json["downloaded"] as? NSNumber {
            downloaded = value.longLongValue
            let formatted = byteFormatter.stringFromByteCount(downloaded)
            downloadedString = formatted
        }

        if let value = json["uploaded"] as? NSNumber {
            uploaded = value.longLongValue
            let formatted = byteFormatter.stringFromByteCount(uploaded)
            uploadedString = formatted
        }

        if let _ratio = json["current_ratio"] as? String {
            ratio = _ratio
        }

        if let str = json["created_at"] as? String {
            if let date = dateFormatter.dateFromString(str) {
                createdAt = date
                createdAtString = mediumDateFormatter.stringFromDate(date)
            }
        }

        if let _error = json["error_message"] as? String {
            error = _error
        }


        if let val = json["peers_connected"] as? NSInteger {
            peersConnceted = Int64(val)
        }

        if let val = json["peers_sending_to_us"] as? NSInteger {
            peersSendingToUs = Int64(val)
        }

        if let val = json["peers_connected"] as? NSInteger {
            seedingFor = Int64(val)
            seedingForString = Util.formatEstimateTime(Int(seedingFor))
        }

        if let val = json["peers_connected"] as? NSInteger {
            peersConnceted = Int64(val)
        }

        if let _status = json["status"] as? String {
            status = _status
        }

        if let _type = json["type"] as? String {
            type = _type
        }

        if let _source = json["source"] as? String {
            source = _source
        }

        if let _isPrivate = json["is_private"] as? Bool {
            isPrivate = _isPrivate
        }

        if let _trackets = json["trackers"] as? NSArray {
            trackers = _trackets
            var str = ""
            for tracker in trackers {
                if let ts = tracker as? String  {
                      str += ts
                }
            }
            trackersString = str
        }

        if let parentId = json["save_parent_id"] as? NSInteger {
            saveParentId = Int64(parentId)
            FileStore.getFile("\(saveParentId)", completionHandler: { (result: File) in
                self.saveParent = result
            })
        }

        if let id = json["file_id"] as? NSInteger {
            fileId = Int64(id)
            FileStore.getFile("\(fileId)", completionHandler: { (result: File) in
                self.file = result
            })
        }
    }
    
    internal func cancel() {
        TransferStore.cancel(self, {_ in })
    }
}