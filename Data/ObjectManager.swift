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
    
    // Downloads/Updates Game data from Parse
    func downloadGames(withPredicate predicate: NSPredicate?, completionHandler: ((success: Bool) -> Void)?) {
        
        let gamesWithObjectId = self.getGameWithObjectIds(withPredicate: predicate)
        
        var query = PFQuery(className:"Game", predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock() {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if let gameObjects = objects where error == nil {
                
                print("Game found: \(objects!.count)")
                
                for gameObject in gameObjects {
                    
                    if let objectId = gameObject.objectId {
                        
                        var game: Game
                        
                        if let gameFound = gamesWithObjectId[objectId] {
                            game = gameFound
                            game.platforms = NSSet()
                            game.characters = NSSet()
                            game.gameTypes = NSSet()
                        } else {
                            game = NSEntityDescription.insertNewObjectForEntityForName("Game", inManagedObjectContext: self.managedContext) as! Game
                        }
                        
                        game.objectId = objectId
                        game.fullName = gameObject["fullName"] as! String
                        game.shortName = gameObject["shortName"] as! String
                        game.primaryLevelMax = gameObject["primaryLevelMax"] as! NSNumber
                        game.primaryLevelMin = gameObject["primaryLevelMin"] as! NSNumber
                        game.secondaryLevelMin = gameObject["secondaryLevelMin"] as! NSNumber
                        game.secondaryLevelMax = gameObject["secondaryLevelMax"] as! NSNumber
                        
                        if let platformsArray = gameObject["platforms"] as? [String],
                            charactersArray = gameObject["characters"] as? [String],
                            playlistArray = gameObject["playlist"] as? [String] {
                                
                                if platformsArray.count > 0 && charactersArray.count > 0 && playlistArray.count > 0 {
                                    
                                    for platformName in platformsArray {
                                        let platform = NSEntityDescription.insertNewObjectForEntityForName("Platform", inManagedObjectContext: self.managedContext) as! Platform
                                        platform.name = platformName
                                        platform.game = game
                                    }
                                    
                                    for characterName in charactersArray {
                                        let character = NSEntityDescription.insertNewObjectForEntityForName("Character", inManagedObjectContext: self.managedContext) as! Character
                                        character.name = characterName
                                        character.game = game
                                    }
                                    
                                    for gameTypeName in playlistArray {
                                        let gameType = NSEntityDescription.insertNewObjectForEntityForName("GameType", inManagedObjectContext: self.managedContext) as! GameType
                                        gameType.name = gameTypeName
                                        gameType.game = game
                                    }
                                }
                        }
                    }
                    
                }
                
                do {
                    try self.managedContext.save()
                    print("Game object(s) saved")
                } catch let error as NSError {
                    print("Could not save downloaded game \(error), \(error.userInfo)")
                }
                
                if let handler = completionHandler {
                    handler(success: true)
                }
            }
            else {
                print("Could not download \(error!), \(error!.userInfo)")
                
                if let handler = completionHandler {
                    handler(success: false)
                }
            }
        }
    }
    
    // Downloads/Updates Post data from Parse
    func downloadPosts(withPredicate predicate: NSPredicate?, completionHandler: ((success: Bool) -> Void)?) {
        
        let gamesWithObjectId = self.getGameWithObjectIds(withPredicate: nil)
        let postsWithObjectId = self.getPostsWithObjectIds(withPredicate: predicate)
        
        var query = PFQuery(className: "Post", predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if let postObjects = objects where error == nil {
                
                print("Posts Count: \(postObjects.count)")
                
                for postObject in postObjects {
                    
                    if let objectId = postObject.objectId,
                        gameId = postObject["gameId"] as? String {
                        
                            if let gameFound = gamesWithObjectId[gameId] {
                                
                                var post: Post
                                
                                if let postFound = postsWithObjectId[objectId] {
                                    post = postFound
                                } else {
                                    post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedContext) as! Post
                                }
                                
                                post.objectId = objectId
                                post.character = postObject["character"] as! String
                                post.console = postObject["console"] as! String
                                post.desc = postObject["description"] as! String
                                post.gameType = postObject["gameType"] as! String
                                post.mic = postObject["mic"] as! Bool
                                post.playerId = postObject["playerId"] as! String
                                post.primaryLevel = postObject["primaryLevel"] as! NSNumber
                                post.secondaryLevel = postObject["secondaryLevel"] as! NSNumber
                                post.game = gameFound
                            }
                    }
                }
                
                do {
                    try self.managedContext.save()
                    print("Post object(s) saved")
                } catch let error as NSError {
                    print("Could not save downloaded posts \(error), \(error.userInfo)")
                }
                
                if let handler = completionHandler {
                    handler(success: true)
                }
            }
            else {
                print("Could not download \(error!), \(error!.userInfo)")
                
                if let handler = completionHandler {
                    handler(success: false)
                }
            }
        })
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
                print("Post has been uploaded.")
            } else {
                print("Post failed to upload. \(error!), \(error!.userInfo)")
            }
            if let handler = completionHandler {
                handler(success: success)
            }
        }
    }
    
    // MARK: Core Data + Parse
    
    // Deletes the Post objects from Parse and Core Data
    func deletePosts(withPredicate predicate: NSPredicate?, completionHandler: ((success: Bool) -> Void)?) {
        
        let postsToDelete = self.getPostsWithObjectIds(withPredicate: predicate)
        let postObjectIds = postsToDelete.keys
        
        for (objectId, post) in postsToDelete {
            self.managedContext.deleteObject(post)
        }
        var success: Bool = false
        
        do {
            try self.managedContext.save()
            print("Post object(s) deleted from core data")
            
            success = true
            
            for objectId in postObjectIds {
                let postObject = PFObject(withoutDataWithClassName: "Post", objectId: objectId)
                postObject.deleteInBackgroundWithBlock({
                    (success: Bool, error: NSError?) -> Void in
                    if success && error == nil {
                        print("Post object deleted from Parse")
                    } else {
                        print("Failed to delete object from the cloud (and core data)")
                    }
                })
            }
            
        } catch let error as NSError {
            print("Could not deleted posts \(error), \(error.userInfo)")
            success = false
        }
        
        if let handler = completionHandler {
            handler(success: success)
        }
    }
    
    // MARK: Helper Methods
    
    func getGameWithObjectIds(withPredicate predicate: NSPredicate?) -> [String: Game] {
        
        let allExistingGames = self.retrieveGames(withPredicate: nil)
        var gamesWithObjectId = [String: Game]()
        
        for game in allExistingGames {
            gamesWithObjectId[game.objectId] = game
        }
        
        return gamesWithObjectId
    }
    
    func getPostsWithObjectIds(withPredicate predicate: NSPredicate?) -> [String: Post] {
        
        let allExistingPosts = self.retrievePosts(withPredicate: predicate)
        var postsWithObjectId = [String: Post]()
        
        for post in allExistingPosts {
            postsWithObjectId[post.objectId] = post
        }
        
        return postsWithObjectId
    }
}
