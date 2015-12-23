//
//  MainNavigationController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-22.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    func togglePanel() {
        if let containerVC = self.parentViewController as? ContainerViewController {
            containerVC.togglePanel()
        }
    }
    
    func showViewForPanelOption(option: PanelOption) {
        switch(option)
        {
        case .Games:
            self.popViewControllerAnimated(true)
            break
        case .Feedback:
            break
        case .Donate:
            break
        case .Help:
            break
        }
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        var panelEnabled = false
        
        if viewController is PostsViewController {
            panelEnabled = true
        }
        
        if let containerVC = self.parentViewController as? ContainerViewController {
            containerVC.panelEnabled = panelEnabled
        }
    }
}
