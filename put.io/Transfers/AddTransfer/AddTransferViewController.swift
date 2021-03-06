//
//  AddTransferViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 11/6/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

@IBDesignable class AddTransferViewController: UIViewController {
    @IBOutlet weak var addButton: PUTButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var resultIcon: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapper = UITapGestureRecognizer(target: self, action: Selector("bodyTapped:"))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        activityIndicator.hidden = true
        resultIcon.hidden = true
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

    func dismiss() {
        dismissViewControllerAnimated(true, completion: {
            self.presentingViewController?.tabBarController?.selectedIndex = 1
            return
        })
    }

    @IBAction func doPaste(sender: AnyObject) {
        let pasteboard = UIPasteboard.generalPasteboard()
        textView.text = pasteboard.string
    }

    @IBAction func cancel(sender: AnyObject) {
        view.endEditing(true)
        dismiss()
    }

    @IBAction func add(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        progressLabel.text = "Submitting..."
        TransferStore.add(textView.text!) { (success:Bool) in
            if success {
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                self.progressLabel.text = "Successfully added!"
                self.resultIcon.textColor = UIColor.greenColor()
                self.resultIcon.text = "✓"
                self.resultIcon.hidden = false
                self.dismiss()
            } else {
                self.activityIndicator.hidden = true
                self.activityIndicator.stopAnimating()
                self.progressLabel.text = "Error!"
                self.resultIcon.textColor = UIColor.redColor()
                self.resultIcon.text = "✗"
                self.resultIcon.hidden = false
            }
        }
    }
}
