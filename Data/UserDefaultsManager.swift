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
    
    func getLastUpdatedPostsDate(forGame gameId: String) -> NSDate {
        var dateDictionary = self.getLastUpdatedPostsDateDictionary()
        var result = dateDictionary[gameId]
        if result == nil {
            result = NSDate.init(timeIntervalSince1970: 1)
        }
        return result!
    }
    
    func setLastUpdatedPostsDate(date: NSDate, gameId: String) {
        var dateDictionary = self.getLastUpdatedPostsDateDictionary()
        dateDictionary[gameId] = date
        userDefaults.setObject(dateDictionary, forKey: LAST_UPDATED_POSTS_DATE_KEY)
    }
    
    func getLastUpdatedPostsDateDictionary() -> [String: NSDate] {
        var result = userDefaults.dictionaryForKey(LAST_UPDATED_POSTS_DATE_KEY) as? [String: NSDate]
        if result == nil {
            result = [String: NSDate]()
        }
        print(result)
        return result!
    }
}