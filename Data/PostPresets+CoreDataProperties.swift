//
//  PostPresets+CoreDataProperties.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-28.
//  Copyright © 2015 Rakesh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PostPresets {

    @NSManaged var character: String
    @NSManaged var createdAt: NSDate
    @NSManaged var desc: String
    @NSManaged var gameId: String
    @NSManaged var gameType: String
    @NSManaged var mic: Bool
    @NSManaged var objectId: String
    @NSManaged var platform: String
    @NSManaged var playerId: String
    @NSManaged var primaryLevel: NSNumber
    @NSManaged var secondaryLevel: NSNumber

}
