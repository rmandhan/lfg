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

struct PseudoPost {
    
    var character: String
    var console: String
    var desc: String
    var gameType: String
    var mic: Bool
    var playerId: String
    var primaryLevel: NSNumber
    var secondaryLevel: NSNumber
    var gameId: String
    
    init (character: String, console: String, desc: String, gameType: String, mic: Bool, playerId: String, primaryLevel: NSNumber, secondaryLevel: NSNumber, gameId: String) {
        self.character = character
        self.console = console
        self.desc = desc
        self.gameType = gameType
        self.mic = mic
        self.playerId = playerId
        self.primaryLevel = primaryLevel
        self.secondaryLevel = secondaryLevel
        self.gameId = gameId
    }
}

class ObjectManager {
    
    static let sharedInstance = ObjectManager()
    
    var appDelegate: AppDelegate
    var managedContext: NSManagedObjectContext
    
    private init() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        managedContext = appDelegate.managedObjectContext
    }
    
    // MARK: Core Data
    
    // Retrieves the Game objects from Core Data
    func retrieveGames(withPredicate predicate: NSPredicate?) -> [Game] {
        
        var games = [Game]()
        
        let fetchRequest = NSFetchRequest(entityName: "Game")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            for result in results {
                if let game = result as? Game {
                    games.append(game)
                } else {
                    print("One of results could not be casted as a Game")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return games
    }
    
    // Retrieves the Post objects from Core Data
    func retrievePosts(withPredicate predicate: NSPredicate?) -> [Post] {
        
        var posts = [Post]()
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            
            for result in results {
                if let post = result as? Post {
                    posts.append(post)
                } else {
                    print("One of results could not be casted as a Post")
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return posts
        
    }
    
    // MARK: Parse
    
    // Downloads Game data from Parse
    func downloadGames(withPredicate predicate: NSPredicate?, completionHandler: (success: Bool) -> Void?) {
        
        // NOTE: Only update games, never delete them - to preserve the relationship with posts, therefore, no relationships are set here. EZPZ
        
        var query = PFQuery(className:"Game", predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock() {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let gameObjects = objects where error == nil {
                print("Game found: \(objects!.count)")
                
                for gameObject in gameObjects {
                    let entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: self.managedContext)
                    let game = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedContext) as! Game
                    
                    game.fullName = gameObject["fullName"] as! String
                    game.shortName = gameObject["shortName"] as! String
                    game.primaryLevelMax = gameObject["primaryLevelMax"] as! NSNumber
                    game.primaryLevelMin = gameObject["primaryLevelMin"] as! NSNumber
                    game.secondaryLevelMin = gameObject["secondaryLevelMin"] as! NSNumber
                    game.secondaryLevelMax = gameObject["secondaryLevelMax"] as! NSNumber
                    
                    if let platformsArray = gameObject["platforms"] as? [String],
                        charactersArray = gameObject["characters"] as? [String],
                        playlistArray = gameObject["playlist"] as? [String] {
                            
                            if platformsArray.count > 0 {
                                for platformName in playlistArray {
                                    let platform = Platform()
                                    platform.name = platformName
                                    platform.game = game
                                }
                            }
                            
                            if charactersArray.count > 0 {
                                for characterName in charactersArray {
                                    let character = Character()
                                    character.name = characterName
                                    character.game = game
                                }
                            }
                            
                            if playlistArray.count > 0 {
                                for gameTypeName in playlistArray {
                                    let gameType = GameType()
                                    gameType.name = gameTypeName
                                    gameType.game = game
                                }
                            }
                    }
                }
                
                do {
                    try self.managedContext.save()
                    print("Game object saved")
                } catch let error as NSError {
                    print("Could not save downloaded game \(error), \(error.userInfo)")
                }
                
                completionHandler(success: true)
            }
            else {
                completionHandler(success: false)
                print("Could not download \(error!), \(error!.userInfo)")
            }
        }
    }
    
    // Downloads Post data from Parse
    func downloadPosts(withPredicate predicate: NSPredicate?, completionHandler: (success: Bool) -> Void?) {
        // NOTE: Set relationship with the game the post belongs to
    }
    
    // Uploads Post data to Parse
    func uploadPost(post: PseudoPost, completionHandler: ((success: Bool) -> Void)?) {
        
        let gameObject = PFObject(withoutDataWithClassName: "Game", objectId: post.gameId)
        let postObject = PFObject(className: "Post")
        
        postObject["console"] = post.console
        postObject["mic"] = post.mic
        postObject["playerId"] = post.playerId
        postObject["character"] = post.character
        postObject["primaryLevel"] = post.primaryLevel
        postObject["secondaryLevel"] = post.secondaryLevel
        postObject["description"] = post.desc
        postObject["gameType"] = post.gameType
        postObject["game"] = gameObject
        postObject["gameId"] = gameObject.objectId
        
        postObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success && error == nil {
                print("postObject has been uploaded.")
            } else {
                print("postObject failed to upload. \(error!), \(error!.userInfo)")
            }
            if let handler = completionHandler {
                handler(success: success)
            }
        }
    }
    
    // MARK: Core Data + Parse
    
    // Deletes the Post objects from Parse and Core Data
    func deletePosts(withPredicate predicate: NSPredicate?, completionHandler: (success: Bool) -> Void?) {
        
    }
    
}
