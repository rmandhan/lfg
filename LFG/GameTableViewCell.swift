//
//  GameTableViewCell.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-05.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameImage: UIImageView!
    
    var gameObjectId: String = ""
    
    func render() {
        if let name = gameName.text {
            switch(name) {
            case BLACK_OPS_3:
                renderBlackOps()
            case DESTINY:
                renderDestiny()
            default:
                renderDefault()
            }
        }
    }
    
    func renderBlackOps() {
        
    }
    
    func renderDestiny() {
        
    }
    
    func renderDefault() {
        
    }
}
