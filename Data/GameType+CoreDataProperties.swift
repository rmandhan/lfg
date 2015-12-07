//
//  GameType+CoreDataProperties.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-03.
//  Copyright © 2015 Rakesh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension GameType {

    @NSManaged var name: String
    @NSManaged var game: Game

}
