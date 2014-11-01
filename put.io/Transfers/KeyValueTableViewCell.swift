//
//  KeyValueTableViewswift
//  put.io
//
//  Created by Mohsen Azimi on 11/1/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit
private let byteFormatter = NSByteCountFormatter()
var dateFormatter = NSDateFormatter()
var mediumDateFormatter = NSDateFormatter()

class KeyValueTableViewCell: UITableViewCell {
    var transfer:NSDictionary?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: .Value1, reuseIdentifier:reuseIdentifier)
        textLabel.font = UIFont.systemFontOfSize(14)
        detailTextLabel?.font = UIFont.systemFontOfSize(12)
        userInteractionEnabled = false
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        mediumDateFormatter.dateStyle = .MediumStyle
        mediumDateFormatter.timeStyle = .MediumStyle
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setValue(index:Int, tr: NSDictionary) {
        self.transfer = tr

        switch index {
            case 0:
            setValueString("Name", value: "name")
            break

            case 1:
            textLabel.text = "Size"
            if let size = transfer!["size"] as? NSNumber {
                detailTextLabel?.text = byteFormatter.stringFromByteCount(size.longLongValue)
            }
            break

            case 2:
            // finished_at
            textLabel.text = "Estimated time"
            if let es = transfer!["estimated_time"] as? NSInteger {
                detailTextLabel?.text = Util.formatEstimateTime(Int(es))
            }
            break

            case 3:
            textLabel.text = "Availability"
            if let av = transfer!["availability"] as? NSInteger {
                detailTextLabel?.text = "\(av)%"
            }
            break

            case 4:
            textLabel.text = "Percentage done"
            if let pd = transfer!["percent_done"] as? NSInteger {
                detailTextLabel?.text = "\(pd)%"
            }
            break

            case 5:
            textLabel.text = "Download Speed"
            if let speed = transfer!["down_speed"] as? NSNumber {
                let formatted = byteFormatter.stringFromByteCount(speed.longLongValue)
                detailTextLabel?.text = "\(formatted)/s"
            }
            break

            case 6:
            textLabel.text = "Upload Speed"
            if let speed = transfer!["down_speed"] as? NSNumber {
                let formatted = byteFormatter.stringFromByteCount(speed.longLongValue)
                detailTextLabel?.text = "\(formatted)/s"
            }
            break

            case 7:
            textLabel.text = "Downloaded"
            if let value = transfer!["downloaded"] as? NSNumber {
                let formatted = byteFormatter.stringFromByteCount(value.longLongValue)
                detailTextLabel?.text = formatted
            }
            break

            case 8:
            textLabel.text = "Uploaded"
            if let value = transfer!["uploaded"] as? NSNumber {
                let formatted = byteFormatter.stringFromByteCount(value.longLongValue)
                detailTextLabel?.text = formatted
            }
            break

            case 9:
            textLabel.text = "Current Ratio"
            detailTextLabel?.text = transfer!["current_ratio"] as? String
            break

            case 10: setValueString("Subscription", value: "subscription_id") //TODO
            break

            case 11:
            textLabel.text = "Created at"
            if let str = transfer!["created_at"] as? String {
                if let date = dateFormatter.dateFromString(str) {
                    detailTextLabel?.text = mediumDateFormatter.stringFromDate(date)
                }
            }
            break

            case 12:
            textLabel.text = "Error"
            if let error =  transfer!["error_message"] as? String {
                detailTextLabel?.text = error
                detailTextLabel?.textColor = UIColor.redColor()
            } else {
                detailTextLabel?.text = "No"
            }
            break

            case 13: setValueString("Magnet link", value: "magneturi")

            break

            case 14:
            textLabel.text = "Connected peers"
            if let val = transfer!["peers_connected"] as? NSInteger {
                detailTextLabel?.text = "\(val)"
            }
            break

            case 15:
            textLabel.text = "Peers getting from us"
            if let val = transfer!["peers_getting_from_us"] as? NSInteger {
                detailTextLabel?.text = "\(val)"
            }
            break

            case 16:
            textLabel.text = "Peers sending to us"
            if let val = transfer!["peers_getting_from_us"] as? NSInteger {
                detailTextLabel?.text = "\(val)"
            }
            break

            case 17:
            textLabel.text = "Seeding for"
            if let seeding = transfer!["seconds_seeding"] as? NSInteger {
                detailTextLabel?.text = Util.formatEstimateTime(Int(seeding))
            }
            break

            case 18:
            textLabel.text = "Downloading to folder"
            detailTextLabel?.text = "Downloads (TODO"
            // detailTextLabel?.text = transfer!["save_parent_id"] as? String
            break

            case 19:
            textLabel.text = "Status"
            detailTextLabel?.text = transfer!["status"] as? String
            break

            case 20:
            textLabel.text = "Type"
            detailTextLabel?.text = transfer!["type"] as? String
            break

            case 21:
            textLabel.text = "Private"
            if let isPrivate = transfer!["is_private"] as? Bool {
                if isPrivate {
                    detailTextLabel?.text = "Yes"
                } else {
                    detailTextLabel?.text = "No"
                }
            }
            break

            case 22:
            textLabel.text = "Source"
            detailTextLabel?.text = transfer!["source"] as? String  //Copy
            break

            case 23:
            textLabel.text = "Trackers"
            if let trackets = transfer!["trackers"] as? NSArray {
                var str = ""
                for tracker in trackets {
                    if let ts = tracker as? String  {
                        str += ts
                    }
                }
                detailTextLabel?.text = str
            }
            break

            default:
            textLabel.text = "Unknown"
            detailTextLabel?.text = ""
        }
    }

    func setValueString(key:String, value:String) {
        textLabel.text = key
        if let value = transfer![value] as? String {
            detailTextLabel?.text = value
        } else {
            detailTextLabel?.text = "N/A"
        }
    }
}
