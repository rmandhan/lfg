//
//  Platform+CoreDataProperties.swift
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

let PC = "PC"
let PC_STEAM = "PC (Steam)"
let PC_OTHER = "PC (Other)"
let PLAYSTATION_3 = "Playstation 3"
let PS3 = "PS3"
let PLAYSTATION_4 = "Playstation 4"
let PS4 = "PS4"
let XBOX_360 = "Xbox 360"
let X360 = "X360"
let XBOX_ONE = "Xbox One"
let XONE = "XOne"
let WII = "Wii"
let WIIU = "Wii U"

extension Platform {

    @NSManaged var name: String
    @NSManaged var game: Game

}
