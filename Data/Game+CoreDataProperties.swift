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

let BLACK_OPS_3 = "Call of Duty Black Ops III"
let DESTINY = "Destiny"

extension Game {

    @NSManaged var objectId: String
    @NSManaged var fullName: String
    @NSManaged var primaryLevelMax: NSNumber
    @NSManaged var primaryLevelMin: NSNumber
    @NSManaged var secondaryLevelMax: NSNumber
    @NSManaged var secondaryLevelMin: NSNumber
    @NSManaged var shortName: String
    @NSManaged var characters: NSSet
    @NSManaged var gameTypes: NSSet
    @NSManaged var platforms: NSSet
    @NSManaged var posts: NSSet?

    var isBlackOps3: Bool {
        if self.fullName == BLACK_OPS_3 {
            return true
        }
        return false
    }
    
    var isDestiny: Bool {
        if self.fullName == DESTINY {
            return true
        }
        return false
    }
    
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
        
        return strings
    }
    
    func gameTypesAsStrings() -> [String] {
        
        var strings = [String]()
        
        for gametype in (self.gameTypes.allObjects as! [GameType]) {
            strings.append(gametype.name)
        }
        
        return strings
    }
    
    func platformsAsStrings() -> [String] {
        
        var strings = [String]()
        
        for platform in (self.platforms.allObjects as! [Platform]) {
            strings.append(platform.name)
        }
        
        return strings
    }
}
