//
//  FullImageFileViewController.swift
//  put.io
//
//  Created by Mohsen Azimi on 12/28/14.
//  Copyright (c) 2014 Mohsen Azimi. All rights reserved.
//

import UIKit

class FullImageFileViewController: FileViewController, UIScrollViewDelegate {
    var url:NSURL!
    var navigationBarBackgroundImage:UIImage!
    var navigationBarShadowImage:UIImage!
    
    @IBOutlet weak var showNavButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    var lastZoomScale: CGFloat = -1
//    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
        tabBarController?.tabBar.hidden = true
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(UIBarMetrics.Default)
        navigationBarShadowImage = navigationController?.navigationBar.shadowImage
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        
    }
    
    func loadImage() {
        dispatch_async(dispatch_get_main_queue()) {
            if let data = NSData(contentsOfURL: self.url){
                if let image = UIImage(data: data) {
                    self.imageView.image = image
                }
            }
        }
    }

    override func loadView() {
        super.loadView()
        let nib = UINib(nibName: "FullImageFileViewController", bundle: nil)
        nib.instantiateWithOwner(self, options: nil)
    }
    
    @IBAction func showNav(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            self.navigationController!.setNavigationBarHidden(!self.navigationController!.navigationBarHidden, animated: true)
            return
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.setBackgroundImage(navigationBarBackgroundImage, forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = navigationBarShadowImage
        navigationController?.navigationBar.translucent = true
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.delegate = self
        updateZoom()
    }
    
    // Update zoom scale and constraints
    // It will also animate because willAnimateRotationToInterfaceOrientation
    // is called from within an animation block
    //
    // DEPRECATION NOTICE: This method is said to be deprecated in iOS 8.0. But it still works.
    override func willAnimateRotationToInterfaceOrientation(
        toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
            
            super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
            updateZoom()
    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = view.bounds.size.width
            let viewHeight = view.bounds.size.height
            
            // center image if it is smaller than screen
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }
    
    // Zoom to show as much image as possible unless image is smaller than screen
    private func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(view.bounds.size.width / image.size.width,
                view.bounds.size.height / image.size.height)
            
            if minZoom > 1 { minZoom = 1 }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }
    
    // UIScrollViewDelegate
    // -----------------------
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
