//
//  ObjectManager.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-03.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import Foundation
import CoreData
import Parse

@objc protocol ObjectManagerDelegate {
    optional func downloadCompleted(withError: NSError?)
    optional func uploadCompleted(withError: NSError?)
}

class ObjectManager {
    
    static let sharedInstance = ObjectManager()
    
    // Retrieves the Game objects from Core Data
    func retrieveGames(withPredicate predicate: NSPredicate?) -> [Game] {
        return [Game]()
    }
    
    // Retrieves the Post objects from Core Data
    func retrievePosts(withPredicate predicate: NSPredicate?) -> [Post] {
        return [Post]()
    }
    
    // Deletes the Game objects from Core Data
    func deleteGames(withPredicate predicate: NSPredicate?) {
        
    }
    
    // Deletes the Post objects from Core Data
    func deletePosts(withPredicate predicate: NSPredicate?) {
        
    }
    
    // Uploads Game data to Parse
    func uploadGame(game: Game) {
        
    }
    
    // Uploads Post data to Parse
    func uploadPost(post: Post) {
        
    }
    
    // Downloads Game data from Parse
    func downloadGames(withPredicate predicate: NSPredicate?) {
        
    }
    
    // Downloads Post data from Parse
    func downloadPosts(withPredicate predicate: NSPredicate?) {
        
    }
    
}
