//
//  PostTableViewCell.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var game: Game?
    var post: Post?
    
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var micLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var primaryLevel: UILabel!
    @IBOutlet weak var secondaryLevel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dividerViewGameType: UIView!
    @IBOutlet weak var dividerViewPlatform: UIView!
    @IBOutlet weak var dividerViewId: UIView!
    @IBOutlet weak var dividerViewCharacter: UIView!
    @IBOutlet weak var dividerViewLevel: UIView!
    
    @IBOutlet weak var descriptionHeightConstraint: NSLayoutConstraint!
    
    func render() {
        if let postObject = self.post, gameObject = self.game {
            self.gameTypeLabel.text = postObject.gameType
            self.platformLabel.text = "Platform: " + postObject.platform
            self.idLabel.text = "Id: " + postObject.playerId
            self.characterLabel.text = "Character: " + postObject.character
            self.primaryLevel.text = gameObject.primaryLevelName + ": " + postObject.primaryLevel.stringValue
            
            if postObject.mic == true {
                self.micLabel.text = "Mic: " + "Yes"
            } else {
                self.micLabel.text = "Mic: " + "No"
            }
            
            if gameObject.secondaryLevelMax != 0 {
                self.secondaryLevel.text = gameObject.secondaryLevelName + ": " + postObject.secondaryLevel.stringValue
            } else {
                self.secondaryLevel.text = ""
                self.dividerViewLevel.hidden = true
            }
            
            if !postObject.desc.isEmpty {
                self.descriptionLabel.text = "Description: " + postObject.desc
            } else {
                self.descriptionHeightConstraint.constant = 0
            }
        }
    }
    
    func cellSelected() {
        print("Post Selected")
    }
}
