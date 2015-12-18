//
//  FilterPostsTableViewCell.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-17.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class FilterPostsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterDescription: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    
    func render() {
        
    }
    
    @IBAction func filterButtonTapped(sender: AnyObject) {
        print("Oh.. Hello there..")
        // TODO: Have a delegate property and use that to present - check this first
        // Presenter's delegate will be this cell ?
    }
}
