//
//  UserDefaultsManager.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-05.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import Foundation

let GAME_ID_KEY = "gameId"

class UserDefaultsManager {
    
    static let sharedInstance = UserDefaultsManager()
    
    let userDefaults: NSUserDefaults
    
    private init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
    }
    
    func getCurrentGameId() -> String {
        return userDefaults.valueForKey(GAME_ID_KEY) as! String
    }
    
    func setCurrentGameId(id: String) {
        userDefaults.setValue(id, forKey: GAME_ID_KEY)
    }
}