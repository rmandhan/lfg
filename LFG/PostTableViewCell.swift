//
//  PostTableViewCell.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var game: Game!
    var post: Post!
    
    @IBOutlet weak var gameTypeLabel: UILabel!
    @IBOutlet weak var postAgeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var platformImage: UIImageView!
    @IBOutlet weak var platformLabel: UILabel!
    @IBOutlet weak var box1Image: UIImageView!
    @IBOutlet weak var playerIdLabel: UILabel!
    @IBOutlet weak var micImage: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var box2Image: UIImageView!
    @IBOutlet weak var primaryLevelLabel: UILabel!
    @IBOutlet weak var box3Image: UIImageView!
    @IBOutlet weak var secondaryLevelLabel: UILabel!
    
    @IBOutlet weak var platformImageTopConstraint: NSLayoutConstraint!
    
    func render() {
        
        self.gameTypeLabel.text = self.post.gameType
        self.platformLabel.text = self.post.platform
        self.playerIdLabel.text = self.post.playerId
        self.characterLabel.text = self.post.character
        self.primaryLevelLabel.text = self.game.primaryLevelName + ": " + self.post.primaryLevel.stringValue
        
        if self.game.secondaryLevelMax != 0 {
            self.secondaryLevelLabel.text = self.game.secondaryLevelName + ": " + self.post.secondaryLevel.stringValue
            self.secondaryLevelLabel.hidden = false
            self.box3Image.hidden = false
        }
        else {
            self.secondaryLevelLabel.text = ""
            self.secondaryLevelLabel.hidden = true
            self.box3Image.hidden = true
        }
        
        if self.post.desc.isEmpty {
            self.descriptionLabel.text = ""
            self.descriptionLabel.hidden = true
            self.platformImageTopConstraint.active = false
        }
        else {
            self.descriptionLabel.text = self.post.desc
            self.descriptionLabel.hidden = false
            self.platformImageTopConstraint.active = true
        }
        
        if self.post.mic {
            self.micImage.image = UIImage(named: "Mic")
        } else {
            self.micImage.image = UIImage(named: "NoMic")
        }
        
        let platform = self.post.platform
        var platformImageName = "PC_Other" // Default Image
        
        if platform == PC || platform == PC_STEAM {
            platformImageName = "PC_Steam"
        }
        else if platform == PLAYSTATION_3 || platform == PS3 || platform == PS4 || platform == PLAYSTATION_4 {
            platformImageName = "Playstation"
        }
        else if platform == XBOX_360 || platform == X360 {
            platformImageName = "Xbox360"
        }
        else if platform == XBOX_ONE || platform == XONE {
            platformImageName = "XboxOne"
        }
        else if platform == WIIU {
            platformImageName = "WiiU"
        }
        
        self.platformImage.image = UIImage(named: platformImageName)
        
        let age = NSDate().timeIntervalSinceDate(self.post.createdAt)
        self.postAgeLabel.text = self.stringFromTimeInterval(age)
    }
    
    // MARK: Helper Methods
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        let minutes = (ti / 60) % 60
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        
        return "\(minutes)m"
    }
}
