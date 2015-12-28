//
//  Game+CoreDataProperties.swift
//  
//
//  Created by Rakesh Mandhan on 2015-12-03.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

// Maybe define in an enum?
let BLACK_OPS_3 = "Call of Duty Black Ops III"
let DESTINY = "Destiny"

extension Game {

    @NSManaged var objectId: String
    @NSManaged var fullName: String
    @NSManaged var shortName: String
    @NSManaged var primaryLevelName: String
    @NSManaged var secondaryLevelName: String
    @NSManaged var primaryLevelMax: NSNumber
    @NSManaged var primaryLevelMin: NSNumber
    @NSManaged var secondaryLevelMax: NSNumber
    @NSManaged var secondaryLevelMin: NSNumber
    @NSManaged var postExpiryTime: NSNumber
    @NSManaged var characters: NSSet
    @NSManaged var gameTypes: NSSet
    @NSManaged var platforms: NSSet
    @NSManaged var posts: NSSet
    
    var hasOnlyOneCharacter: Bool {
        if self.characters.count == 1 {
            return true
        }
        return false
    }
    
    var hasOnlyOneGameType: Bool {
        if self.gameTypes.count == 1 {
            return true
        }
        return false
    }
    
    var hasOnlyOnePlatform: Bool {
        if self.platforms.count == 1 {
            return true
        }
        return false
    }
    
    var postsCanBeFiltered: Bool {
        if self.platforms.count > 1 || self.gameTypes.count > 1 {
            return true
        }
        return false
    }
    
    func firstCharacter() -> String {
        
        var result = ""
        
        if self.characters.count > 0 {
            let characters = self.characters.allObjects as! [Character]
            result = characters[0].name
        }
        
        return result
    }
    
    func firstGameType() -> String {
        
        var result = ""
        
        if self.gameTypes.count > 0 {
            let gameTypes = self.gameTypes.allObjects as! [GameType]
            result = gameTypes[0].name
        }
        
        return result
    }
    
    func firstPlatform() -> String {
        
        var result = ""
        
        if self.platforms.count > 0 {
            let platforms = self.platforms.allObjects as! [Platform]
            result = platforms[0].name
        }
        
        return result
    }
    
    func charactersAsStrings() -> [String] {
        
        var strings = [String]()
        
        for character in (self.characters.allObjects as! [Character]) {
            strings.append(character.name)
        }
        
        strings.sortInPlace({ $0 < $1 })
        
        return strings
    }
    
    func gameTypesAsStrings() -> [String] {
        
        var strings = [String]()
        
        for gametype in (self.gameTypes.allObjects as! [GameType]) {
            strings.append(gametype.name)
        }
        
        strings.sortInPlace({ $0 < $1 })
        
        return strings
    }
    
    func platformsAsStrings() -> [String] {
        
        var strings = [String]()
        
        for platform in (self.platforms.allObjects as! [Platform]) {
            strings.append(platform.name)
        }
        
        strings.sortInPlace({ $0 < $1 })
        
        return strings
    }
    
    func recentPostsSortedByDate() -> [Post] {
        
        let allPosts = self.posts.allObjects as! [Post]
        var result = [Post]()
        
        if self.postExpiryTime.integerValue != -1 {
            let xHoursAgo = NSDate(timeIntervalSinceNow: NSTimeInterval.init(self.postExpiryTime.integerValue*(-1)))
            result = allPosts.filter({ return $0.createdAt.compare(xHoursAgo) == NSComparisonResult.OrderedDescending })
        }
        else {
            result = allPosts
        }
        
        result.sortInPlace({ $0.createdAt.compare($1.createdAt) == .OrderedDescending })
        
        return result
    }
    
    func applyDefaultFiltersToPosts(posts: [Post]) -> [Post] {
        
        var filteredPosts = posts

        if let platform = UserDefaultsManager.sharedInstance.getDefaultPlatformsFilterValue() where self.platformsAsStrings().contains(platform) {
            filteredPosts = filteredPosts.filter({ $0.platform == platform })
        }
        
        if let gameType = UserDefaultsManager.sharedInstance.getDefaultGameTypesFilterValue() where self.gameTypesAsStrings().contains(gameType) {
            filteredPosts = filteredPosts.filter({ $0.gameType == gameType })
        }
        
        return filteredPosts
    }
    
}
