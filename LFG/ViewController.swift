//
//  ViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-02.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var i = 0
        
        for i = 0; i < 1; i++ {
            var query = PFQuery(className:"Game")
            query.findObjectsInBackgroundWithBlock() {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil && objects != nil {
                    print("Game Count: \(objects!.count)")
                    for object in objects! {
                        print(object)
                        let postObject = PFObject(className: "Post")
                        postObject["console"] = "PS4"
                        postObject["mic"] = true
                        postObject["playerId"] = "Rakesh-"
                        postObject["character"] = "Titan"
                        postObject["primaryLevel"] = 40
                        postObject["secondaryLevel"] = 310
                        postObject["description"] = "IT WORKS!!!"
                        postObject["gameType"] = "Crucible - Trials of Osiris"
                        postObject["game"] = object
                        postObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                            print("postObject has been saved.")
                        }
                    }
                    
                } else {
                    print(error)
                }
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

