//
//  PseudoPost.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-15.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import Foundation

struct PseudoPost {
    
    var character: String
    var platform: String
    var desc: String
    var gameType: String
    var mic: Bool
    var playerId: String
    var primaryLevel: NSNumber
    var secondaryLevel: NSNumber
    var gameId: String
    
    init (character: String, platform: String, desc: String, gameType: String, mic: Bool, playerId: String, primaryLevel: NSNumber, secondaryLevel: NSNumber, gameId: String) {
        self.character = character
        self.platform = platform
        self.desc = desc
        self.gameType = gameType
        self.mic = mic
        self.playerId = playerId
        self.primaryLevel = primaryLevel
        self.secondaryLevel = secondaryLevel
        self.gameId = gameId
    }
}