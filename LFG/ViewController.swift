//
//  ViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-02.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit
import Parse
import CoreData

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let posts = ObjectManager.sharedInstance.retrievePosts(withPredicate: nil)

        for post in posts {
            print(post.character)
            print(post.console)
            print(post.desc)
            print(post.gameType)
            print(post.mic)
            print(post.playerId)
            print(post.primaryLevel)
            print(post.secondaryLevel)
        }
        
//        let games = ObjectManager.sharedInstance.retrieveGames(withPredicate: nil)
//        
//        for game in games {
//            print(game.fullName)
//            print(game.shortName)
//            print(game.primaryLevelMin)
//            print(game.primaryLevelMax)
//            print(game.secondaryLevelMin)
//            print(game.secondaryLevelMax)
//        }
        
        
        //        var query = PFQuery(className:"Game", predicate: nil)
        //
        //        query.findObjectsInBackgroundWithBlock() {
        //            (objects: [PFObject]?, error: NSError?) -> Void in
        //
        //            if let gameObjects = objects where error == nil {
        //                print("Game found: \(objects!.count)")
        //
        //                for gameObject in gameObjects {
        //                    if gameObject["shortName"] as! String == "Blops" {
        //                        let testPost = PseudoPost(character: "Annihilator", console: "Xbox One", desc: "HELLO MY NAME IS", gameType: "Team DeathMatch", mic: false, playerId: "Rocket", primaryLevel: 1, secondaryLevel: 10, gameId: gameObject.objectId!)
        //                        ObjectManager.sharedInstance.uploadPost(testPost, completionHandler: {
        //                            (success: Bool) -> Void in
        //                            if success {
        //                                print("Cool")
        //                            }
        //                        })
        //                    }
        //                }
        //            }
        //        }
        
        
        //        var i = 0
        //
        //        for i = 0; i < 1; i++ {
        
        //        let appDelegate =
        //        UIApplication.sharedApplication().delegate as! AppDelegate
        //        let managedContext = appDelegate.managedObjectContext
        //
        //        let fetchRequest = NSFetchRequest(entityName: "Game")
        //
        //        do {
        //            let results = try managedContext.executeFetchRequest(fetchRequest)
        //            print((results.first as! Game).fullName)
        //            print((results.first as! Game).shortName)
        //            print((results.first as! Game).primaryLevelMin)
        //            print((results.first as! Game).primaryLevelMax)
        //            print((results.first as! Game).secondaryLevelMin)
        //            print((results.first as! Game).secondaryLevelMax)
        //        } catch let error as NSError {
        //            print("Could not fetch \(error), \(error.userInfo)")
        //        }
        
        //savePost()
        
//                var query = PFQuery(className:"Game")
//                query.findObjectsInBackgroundWithBlock() {
//                    (objects: [PFObject]?, error: NSError?) -> Void in
//                    if error == nil && objects != nil {
//                        print("Game Count: \(objects!.count)")
//        
//                        if let object = objects?.first {
//                            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                            let managedContext = appDelegate.managedObjectContext
//        
//                            let entity = NSEntityDescription.entityForName("Game", inManagedObjectContext: managedContext)
//                            let game = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Game
//        
//        
//                            game.fullName = object["fullName"] as! String
//                            game.primaryLevelMax = object["primaryLevelMax"] as! NSNumber
//                            game.primaryLevelMin = object["primaryLevelMin"] as! NSNumber
//                            game.secondaryLevelMin = object["secondaryLevelMin"] as! NSNumber
//                            game.secondaryLevelMax = object["secondaryLevelMax"] as! NSNumber
//                            game.shortName = object["shortName"] as! String
//        
//                            do {
//                                try managedContext.save()
//                                print("Game object saved")
//                            } catch let error as NSError {
//                                print("Could not save \(error), \(error.userInfo)")
//                            }
//                        }
//        
//                    } else {
//                        print(error)
//                    }
//                }
//        
//                }

//        var query = PFQuery(className:"Post")
//        query.findObjectsInBackgroundWithBlock() {
//            (objects: [PFObject]?, error: NSError?) -> Void in
//            if error == nil && objects != nil {
//                print("Post Count: \(objects!.count)")
//                
//                if let object = objects?.first {
//                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//                    let managedContext = appDelegate.managedObjectContext
//                    
//                    let entity = NSEntityDescription.entityForName("Post", inManagedObjectContext: managedContext)
//                    let post = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext) as! Post
//                    
//                    
//                    print(post.character)
//                    print(post.console)
//                    print(post.desc)
//                    print(post.gameType)
//                    print(post.mic)
//                    print(post.playerId)
//                    print(post.primaryLevel)
//                    print(post.secondaryLevel)
//                    
//                    post.character = object["character"] as! String
//                    post.console = object["console"] as! String
//                    post.desc = object["description"] as! String
//                    post.gameType = object["console"] as! String
//                    post.mic = object["mic"] as! Bool
//                    post.playerId  = object["playerId"] as! String
//                    post.primaryLevel  = object["primaryLevel"] as! NSNumber
//                    post.secondaryLevel  = object["secondaryLevel"] as! NSNumber
//                    
//                    do {
//                        try managedContext.save()
//                        print("Post object saved")
//                    } catch let error as NSError {
//                        print("Could not save \(error), \(error.userInfo)")
//                    }
//                }
//                
//            } else {
//                print(error)
//            }
//        }

    
    }

    func savePostWithObjectId() {
        let postObject = PFObject(className: "Post")
        postObject["console"] = "PS4"
        postObject["mic"] = true
        postObject["playerId"] = "Rakesh-"
        postObject["character"] = "Titan"
        postObject["primaryLevel"] = 40
        postObject["secondaryLevel"] = 310
        postObject["description"] = "IT WORKS!!!"
        postObject["gameType"] = "Crucible - Trials of Osiris"
        let gameObject = PFObject(withoutDataWithClassName: "Game", objectId: "VZU8gxtObH")
        postObject["game"] = gameObject
        postObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("postObject has been saved.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

