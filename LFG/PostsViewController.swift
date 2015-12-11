//
//  PostsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var game: Game?
    var allPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Posts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PostTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.clearColor()
        
        loadPosts()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func loadPosts() {
        
        if game == nil {
            let gameId = UserDefaultsManager.sharedInstance.getCurrentGameId()
            let gamePredicate = NSPredicate(format: "objectId == %@", gameId)
            let gamesFound = ObjectManager.sharedInstance.retrieveGames(withPredicate: gamePredicate)
            if gamesFound.count > 0 { game = gamesFound[0] }
        }
        
        if let currentGame = game {
            let predicate = NSPredicate(format: "game == %@", currentGame)
            allPosts = ObjectManager.sharedInstance.retrievePosts(withPredicate: predicate)
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 170
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell
        cell.post = allPosts[indexPath.row]
        cell.render()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
        cell.cellSelected()
    }
    
    // MARK: Actions
    
    // TEMP: Takes user back to the Games list
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToAddPostViewController" {
            let nvc = segue.destinationViewController as! UINavigationController
            if let addPostViewConroller = nvc.topViewController as? AddPostViewController {
                addPostViewConroller.game = self.game
            }
        }
    }
}
