//
//  ContainerViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-21.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class ContainerViewController: ViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    // This value matches the left menu's width in the Storyboard
    let leftMenuWidth: CGFloat = 200
    var panelEnabled = false {
        didSet {
            self.scrollView.scrollEnabled = panelEnabled
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dispatch_async(dispatch_get_main_queue()) {
            self.closePanel(animated: false)
        }
    }
    
    func togglePanel() {
        if self.panelEnabled {
            print("Panel toggled")
            scrollView.contentOffset.x == 0  ? closePanel(animated: true) : openPanel()
        }
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup
    func openPanel() {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // Use scrollview content offset-x to slide the menu.
    func closePanel(animated animated: Bool){
        scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollView.pagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollView.pagingEnabled = false
    }
}
