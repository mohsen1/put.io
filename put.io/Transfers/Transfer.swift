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

    var id: Int                     = -1
    var name: String                = "Unknown"
    var size: Int                   = 0
    var sizeString: String          = ""
    var magnetUri: String           = "N/A"
    var estimatedTime: Int          = 0
    var estimatedTimeString: String = ""
    var availability: Int           = 0
    var availabilityString: String  = "N/A"
    var percentDone: Int            = 0
    var percentDoneString: String   = "N/A"
    var downloadSpeed: Int          = 0
    var downloadSpeedString: String = "N/A"
    var uploadSpeed: Int            = 0
    var updoadSpeedString: String   = "N/A"
    var downloaded: Int             = 0
    var downloadedString: String    = "N/A"
    var uploaded: Int               = 0
    var uploadedString: String      = "N/A"
    var ratio: String               = "N/A"
    var createdAt: NSDate?          = nil
    var createdAtString: String     = "N/A"
    var error: String               = "No error"
    var peersConnceted: Int         = 0
    var peersGettingFromUs: Int     = 0
    var peersSendingToUs: Int       = 0
    var seedingFor: Int             = 0
    var seedingForString: String    = "N/A"
    var status: String              = ""
    var type: String                = ""
    var source: String              = ""
    var isPrivate: Bool             = false
    var trackers: NSArray           = NSArray()
    var trackersString: String      = ""
    var saveParentId: Int           = 0
    var fileId: Int                 = 0
    var saveParent: File?
    var file: File?

    init (json:NSDictionary) {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        mediumDateFormatter.dateStyle = .MediumStyle
        mediumDateFormatter.timeStyle = .MediumStyle

        if let _id = json["id"] as? Int {
            id = _id
        }

        if let _name = json["name"] as? String {
            name = _name
        }

        if let _size = json["size"] as? Int {
            size = _size
            sizeString = byteFormatter.stringFromByteCount(Int64(size))
        }

        if let _magnetUri = json["magnetUri"] as? String {
            magnetUri = _magnetUri
        }

        if let _estimatedTime = json["estimated_time"] as? Int {
            estimatedTimeString = Util.formatEstimateTime(_estimatedTime)
            estimatedTime = _estimatedTime
        }

        if let av = json["availability"] as? Int {
            availabilityString = "\(av)%"
            availability = av
        }

        if let pd = json["percent_done"] as? Int {
            percentDoneString = "\(pd)%"
            percentDone = pd
        }

        if let speed = json["down_speed"] as? Int {
            downloadSpeed = speed
            let formatted = byteFormatter.stringFromByteCount(Int64(downloadSpeed))
            downloadSpeedString = "\(formatted)/s"
        }

        if let speed = json["up_speed"] as? Int {
            uploadSpeed = speed
            let formatted = byteFormatter.stringFromByteCount(Int64(uploadSpeed))
            updoadSpeedString = "\(formatted)/s"
        }

        if let value = json["downloaded"] as? Int {
            downloaded = value
            let formatted = byteFormatter.stringFromByteCount(Int64(downloaded))
            downloadedString = formatted
        }

        if let value = json["uploaded"] as? Int {
            uploaded = value
            let formatted = byteFormatter.stringFromByteCount(Int64(uploaded))
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


        if let val = json["peers_connected"] as? Int {
            peersConnceted = Int  (val)
        }

        if let val = json["peers_sending_to_us"] as? Int {
            peersSendingToUs = Int  (val)
        }

        if let val = json["seconds_seeding"] as? Int {
            seedingFor = Int  (val)
            seedingForString = Util.formatEstimateTime(seedingFor)
        }

        if let val = json["peers_connected"] as? Int {
            peersConnceted = Int  (val)
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

        if let parentId = json["save_parent_id"] as? Int {
            saveParentId = parentId
        }

        if let id = json["file_id"] as? Int {
            fileId = id
        }
    }

    internal func cancel(completionHandler: (NSError?)->()) {
        TransferStore.cancel(self, completionHandler)
    }
    
    internal func fetchFile(completionHandler: (File?)->()) {
        TransferStore.fetchFile(self, completionHandler)
    }
}