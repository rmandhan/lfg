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

extension Game {

    @NSManaged var objectId: String
    @NSManaged var fullName: String
    @NSManaged var primaryLevelMax: NSNumber
    @NSManaged var primaryLevelMin: NSNumber
    @NSManaged var secondaryLevelMax: NSNumber
    @NSManaged var secondaryLevelMin: NSNumber
    @NSManaged var shortName: String
    @NSManaged var characters: Character
    @NSManaged var gameTypes: GameType
    @NSManaged var platforms: Platform
    @NSManaged var posts: NSSet?

}
