//
//  DonateViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-23.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class DonateViewController: ViewController {
    
    @IBOutlet var proceedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Donate"
    }
    
    @IBAction func proceedButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:"https://www.paypal.me/LookingForGamersiOS")!)
    }
    
}