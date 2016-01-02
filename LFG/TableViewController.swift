//
//  TableViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-21.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

// Used as parent class for all table view controllers
class TableViewController: UITableViewController {
    
    var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeLoadingIndicator()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeLoadingIndicator() {
        self.loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 40, 40))
        self.loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.loadingIndicator.hidesWhenStopped = true
        self.setLoadingIndicatorCenter()
        self.view.addSubview(self.loadingIndicator)
    }
    
    func rotated() {
        if self.loadingIndicator != nil {
            self.setLoadingIndicatorCenter()
        }
    }
    
    // MARK: Helper Methods
    
    func setLoadingIndicatorCenter() {
        if let navController = self.navigationController {
            self.loadingIndicator.center = CGPoint(x: self.view.center.x, y: self.view.center.y - navController.navigationBar.bounds.height)
        }
        else {
            self.loadingIndicator.center = self.view.center
        }
    }

}
