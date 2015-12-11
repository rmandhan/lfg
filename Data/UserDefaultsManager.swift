//
//  UserDefaultsManager.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-05.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import Foundation

let GAME_ID_KEY = "gameId"
let LAST_UPDATED_POSTS_DATE_KEY = "LastUpdatedPostsDate"
let LAST_POST_FOR_GAMES = "LastPostForGames"

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
    
    func getLastUpdatedPostsDate() -> NSDate {
        return userDefaults.valueForKey(LAST_UPDATED_POSTS_DATE_KEY) as! NSDate
    }
    
    func setLastUpdatedPostsDate(date: NSDate) {
        userDefaults.setObject(date, forKey: LAST_UPDATED_POSTS_DATE_KEY)
    }
}