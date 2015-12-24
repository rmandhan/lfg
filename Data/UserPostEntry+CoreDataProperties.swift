//
//  UserPostEntry+CoreDataProperties.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-23.
//  Copyright © 2015 Rakesh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension UserPostEntry {

    @NSManaged var gameId: String
    @NSManaged var mic: NSNumber
    @NSManaged var platform: String
    @NSManaged var playerId: String
    @NSManaged var primaryLevel: NSNumber
    @NSManaged var secondaryLevel: NSNumber

}
