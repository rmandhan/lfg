//
//  UserDefaultsManager.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-05.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import Foundation

// Used to keep track of the current game
let GAME_ID_KEY = "GameId"
// Used to know if games were downloaded this app. session
let GAME_DOWNLOADED_STATE_KEY = "GamesDownloadedState"
// Used to set default filter value for Platforms
let DEFAULT_PLATFORMS_FILTER_KEY = "DefaultPlatformsFilter"
// Used to set default filter value for Game Types
let DEFAULT_GAMETYPES_FILTER_KEY = "DefaultGameTypesFilter"
// Used to check how long it has been since the last "posts" download for a specific game
let LAST_UPDATED_POSTS_DATE_KEY = "LastUpdatedPostsDate"

class UserDefaultsManager {
    
    static let sharedInstance = UserDefaultsManager()
    
    let userDefaults: NSUserDefaults
    
    private init() {
        userDefaults = NSUserDefaults.standardUserDefaults()
    }
    
    func getCurrentGameId() -> String? {
        return userDefaults.valueForKey(GAME_ID_KEY) as? String
    }
    
    func setCurrentGameId(id: String) {
        userDefaults.setValue(id, forKey: GAME_ID_KEY)
    }
    
    func getGamesDownloadedState() -> Bool {
        return userDefaults.valueForKey(GAME_DOWNLOADED_STATE_KEY) as! Bool
    }
    
    func setGamesDownloadedState(state: Bool) {
        userDefaults.setBool(state, forKey: GAME_DOWNLOADED_STATE_KEY)
    }
    
    func getDefaultPlatformsFilterValue() -> String? {
        return userDefaults.valueForKey(DEFAULT_PLATFORMS_FILTER_KEY) as? String
    }
    
    func setDefaultPlatformsFilterValue(platform: String?) {
        userDefaults.setValue(platform, forKey: DEFAULT_PLATFORMS_FILTER_KEY)
    }
    
    func getDefaultGameTypesFilterValue() -> String? {
        return userDefaults.valueForKey(DEFAULT_GAMETYPES_FILTER_KEY) as? String
    }
    
    func setDefaultGameTypesFilterValue(gameType: String?) {
        userDefaults.setValue(gameType, forKey: DEFAULT_GAMETYPES_FILTER_KEY)
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
        return result!
    }
}