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

class ObjectManager {
    
    static let sharedInstance = ObjectManager()
    
    var appDelegate: AppDelegate
    var masterContext: NSManagedObjectContext
    var mainContext: NSManagedObjectContext
    
    private init() {
        
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        masterContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        mainContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        
        masterContext.persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
        mainContext.parentContext = masterContext
    }
    
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
    func retrievePosts(withGameId gameId: String?, predicate: NSPredicate?) -> [Post] {
        
        var posts = [Post]()
        
        let fetchRequest = NSFetchRequest(entityName: "Post")
        fetchRequest.predicate = predicate
        fetchRequest.pred
        
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
                        
                        if game.primaryLevelMax.integerValue != 0 {
                            game.primaryLevelName = gameObject["primaryLevelName"] as! String
                        }
                        
                        if game.secondaryLevelMax.integerValue != 0 {
                            game.secondaryLevelName = gameObject["secondaryLevelName"] as! String
                        }
                        
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
    
    // TODO: Refactor the two methods below
    
    // Downloads/Updates all Post data from Parse
    func downloadAllPosts(withPredicate predicate: NSPredicate?, completionHandler: ((success: Bool) -> Void)?) {
        
        let gamesWithObjectId = self.getGameWithObjectIds(withPredicate: nil)
        let postsWithObjectId = self.getPostsWithObjectIds(withPredicate: predicate)
        
        let downloadDate = NSDate()
        // Always get posts that are at max 2 hours old
        let twoHoursAgo = NSDate(timeIntervalSinceNow: -7200)
        
        var query = PFQuery(className: "Post", predicate: predicate)
//        query.whereKey("updatedAt", greaterThanOrEqualTo: twoHoursAgo)
        
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
                                post.gameId = postObject["gameId"] as! String
                                post.character = postObject["character"] as! String
                                post.platform = postObject["platform"] as! String
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
                    
                    for key in gamesWithObjectId.keys {
                        UserDefaultsManager.sharedInstance.setLastUpdatedPostsDate(downloadDate, gameId: key)
                    }
                    
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
    
    // Downloads/Updates Post data from Parse specified by a game Id (more flexibility here)
    func downloadPosts(withPredicate predicate: NSPredicate?, gameId: String, completionHandler: ((success: Bool) -> Void)?) {
        
        let gamesWithObjectId = self.getGameWithObjectIds(withPredicate: nil)
        
        // Maybe improve this in the future
        let gamePredicate = NSPredicate(format: "gameId == %@", gameId)
        let postsWithObjectId = self.getPostsWithObjectIds(withPredicate: gamePredicate)
        
        let downloadDate = NSDate()
        // Always get posts that are at max 2 hours old
        let twoHoursAgo = NSDate(timeIntervalSinceNow: -7200)
        
        var query = PFQuery(className: "Post", predicate: predicate)
        query.whereKey("gameId", equalTo: gameId)
        //        query.whereKey("updatedAt", greaterThanOrEqualTo: twoHoursAgo)
        
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if let postObjects = objects where error == nil {
                
                print("Posts Count: \(postObjects.count)")
                
                for postObject in postObjects {
                    
                    if let objectId = postObject.objectId {
                            
                            if let gameFound = gamesWithObjectId[gameId] {
                                
                                var post: Post
                                
                                if let postFound = postsWithObjectId[objectId] {
                                    post = postFound
                                } else {
                                    post = NSEntityDescription.insertNewObjectForEntityForName("Post", inManagedObjectContext: self.managedContext) as! Post
                                }
                                
                                post.objectId = objectId
                                post.gameId = postObject["gameId"] as! String
                                post.character = postObject["character"] as! String
                                post.platform = postObject["platform"] as! String
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
                    UserDefaultsManager.sharedInstance.setLastUpdatedPostsDate(downloadDate, gameId: gameId)
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
        
        postObject["platform"] = post.platform
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
