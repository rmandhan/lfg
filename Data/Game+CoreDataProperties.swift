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
}
