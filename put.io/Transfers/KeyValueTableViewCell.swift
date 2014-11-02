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
    var transfer:Transfer!

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

    func setValue(index:Int, tr: Transfer) {
        self.transfer = tr

        switch index {
            case 0:
            textLabel.text = "Name"
            detailTextLabel?.text = transfer!.name
            break

            case 1:
            textLabel.text = "Size"
            detailTextLabel?.text = transfer!.sizeString
            break

            case 2:
            textLabel.text = "Estimated time"
            detailTextLabel?.text = transfer!.estimatedTimeString
            break

            case 3:
            textLabel.text = "Availability"
            detailTextLabel?.text = transfer!.availabilityString
            break

            case 4:
            textLabel.text = "Percentage done"
            detailTextLabel?.text = transfer!.percentDoneString
            break

            case 5:
            textLabel.text = "Download Speed"
            detailTextLabel?.text = transfer!.downloadSpeedString
            break

            case 6:
            textLabel.text = "Upload Speed"
            detailTextLabel?.text = transfer!.updoadSpeedString
            break

            case 7:
            textLabel.text = "Downloaded"
            detailTextLabel?.text = transfer!.downloadedString
            break

            case 8:
            textLabel.text = "Uploaded"
            detailTextLabel?.text = transfer!.uploadedString
            break

            case 9:
            textLabel.text = "Current Ratio"
            detailTextLabel?.text = transfer!.ratio
            break

            case 10:
            textLabel.text = "Subscription"
            detailTextLabel?.text = "N/A" // TODO
            break

            case 11:
            textLabel.text = "Created at"
            detailTextLabel?.text = transfer!.createdAtString
            break

            case 12:
            textLabel.text = "Error"
            detailTextLabel?.text = transfer!.error
            break

            case 13:
            textLabel.text = "Magnet link"
            detailTextLabel?.text = transfer!.magnetUri
            break

            case 14:
            textLabel.text = "Connected peers"
            detailTextLabel?.text = "\(transfer!.peersConnceted)"
            break

            case 15:
            textLabel.text = "Peers getting from us"
            detailTextLabel?.text = "\(transfer!.peersGettingFromUs)"
            break

            case 16:
            textLabel.text = "Peers sending to us"
            detailTextLabel?.text = "\(transfer!.peersSendingToUs)"
            break

            case 17:
            textLabel.text = "Seeding for"
            detailTextLabel?.text = transfer!.seedingForString
            break

            case 18:
            textLabel.text = "Downloading to folder"
            detailTextLabel?.text = transfer!.saveParent?.name
            break

            case 19:
            textLabel.text = "Status"
            detailTextLabel?.text = transfer!.status
            break

            case 20:
            textLabel.text = "Type"
            detailTextLabel?.text = transfer!.type
            break

            case 21:
            textLabel.text = "Private"
            if transfer!.isPrivate {
                detailTextLabel?.text = "Yes"
            } else {
                detailTextLabel?.text = "No"
            }
            break

            case 22:
            textLabel.text = "Source"
            detailTextLabel?.text = transfer!.source
            break

            case 23:
            textLabel.text = "Trackers"
            detailTextLabel?.text = transfer!.trackersString
            break

            default:
            textLabel.text = "Unknown"
            detailTextLabel?.text = ""
        }
    }
}
