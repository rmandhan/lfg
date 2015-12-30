//
//  ContainerViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-21.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class ContainerViewController: ViewController, UIScrollViewDelegate , PanelDelegate {
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    // This value matches the left menu's width in the Storyboard
    let leftMenuWidth: CGFloat = 200
    
    var panelSelectedOption = PanelOption.Games
    var panelOptionSelected = false
    var panelEnabled = false {
        didSet {
            self.scrollView.scrollEnabled = panelEnabled
        }
    }
    
     var mainNVC: MainNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.closePanel(animated: false)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func rotated(){
        if UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            dispatch_async(dispatch_get_main_queue()) {
                print("Closing menu on rotate")
                self.closePanel(animated: true)
            }
        }
    }
    
    func togglePanel() {
        if self.panelEnabled {
            print("Panel toggled")
            self.scrollView.contentOffset.x == 0  ? closePanel(animated: true) : openPanel()
        }
    }
    
    // Open is the natural state of the menu because of how the storyboard is setup
    func openPanel() {
        
        self.scrollView.userInteractionEnabled = false
        
        UIView.animateWithDuration(0.3,
            animations: {
                self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
            },
            completion: {
                (Bool) -> Void in
                self.scrollView.userInteractionEnabled = true
            }
        )
    }
    
    // Use scrollview content offset-x to slide the menu.
    func closePanel(animated animated: Bool) {
        
        if animated {
            self.scrollView.userInteractionEnabled = false
            
            UIView.animateWithDuration(0.3,
                animations: {
                    self.scrollView.contentOffset = CGPoint(x: self.leftMenuWidth, y: 0)
                },
                completion: {
                    (Bool) -> Void in
                    self.scrollView.userInteractionEnabled = true
                    
                    if self.panelOptionSelected {
                        self.panelOptionSelected = false
                        self.mainNVC?.showViewForPanelOption(self.panelSelectedOption)
                    }
                }
            )
        }
        else {
            self.scrollView.setContentOffset(CGPoint(x: leftMenuWidth, y: 0), animated: animated)
        }
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "mainView" {
            self.mainNVC = segue.destinationViewController as! MainNavigationController
        } else if segue.identifier == "panelView" {
            let panelNVC = segue.destinationViewController as! UINavigationController
            let panelVC = panelNVC.topViewController as! PanelViewController
            panelVC.delegate = self
        }
    }
    
    // MARK: PanelDelegate
    
    func userDidSelectPanelOption(option: PanelOption) {
        self.closePanel(animated: true)
        panelSelectedOption = option
        panelOptionSelected = true
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.viewsEnabled(false)
        self.scrollView.pagingEnabled = true
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.viewsEnabled(true)
        self.scrollView.pagingEnabled = false
    }
    
    // MARK: Helper Methods
    
    func viewsEnabled(enabled: Bool) {
        self.panelView.userInteractionEnabled = enabled
        self.mainView.userInteractionEnabled = enabled
    }
    
}
