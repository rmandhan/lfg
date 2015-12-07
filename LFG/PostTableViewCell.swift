//
//  PostTableViewCell.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var post: Post?
    
    @IBOutlet weak var faltooLabel: UILabel!
    
    func render() {
        if let postObject = post {
            faltooLabel.text = "Object Id: \(postObject.objectId) \n" +
                "Character: \(postObject.character) \n" +
                "Console: \(postObject.console) \n" +
                "Description: \(postObject.desc) \n" +
                "Game Type: \(postObject.gameType) \n" +
                "Mic: \(postObject.mic) \n" +
                "Player Id: \(postObject.playerId) \n" +
                "Primary Level: \(postObject.primaryLevel) \n" +
            "Secondary Level: \(postObject.secondaryLevel)"
        }
    }
    
    func cellSelected() {
        print("Post Selected")
    }
}
