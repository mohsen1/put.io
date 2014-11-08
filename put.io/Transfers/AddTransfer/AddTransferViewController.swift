//
//  AddTransferViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/6/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class AddTransferViewController: UIViewController {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapper = UITapGestureRecognizer(target: self, action: Selector("bodyTapped:"))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func bodyTapped(sender:UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let kbFrame:NSValue = info[UIKeyboardFrameEndUserInfoKey]! as NSValue
        let duration:NSTimeInterval = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        let keyboardFrame:CGRect = kbFrame.CGRectValue()
        let height:CGFloat = keyboardFrame.size.height
        bottomHeight.constant = height
        UIView.animateWithDuration(duration, animations: {
            self.view.layoutIfNeeded()
        })
    }

    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let duration:NSTimeInterval = info[UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        bottomHeight.constant = 8
        UIView.animateWithDuration(duration, animations: {
            self.view.layoutIfNeeded()
        })
    }

    @IBAction func cancel(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func add(sender: AnyObject) {
    }
}
