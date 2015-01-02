//
//  PUTButton.swift
//  put.io
//
//  Created by Mohsen Azimi on 1/1/15.
//  Copyright (c) 2015 Mohsen Azimi. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable class PUTButton: UIButton {
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.blackColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
}
