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
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    lazy var refreshControl = UIRefreshControl()
    
    var game: Game?
    var allPosts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Posts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshPosts:", forControlEvents: UIControlEvents.ValueChanged)
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PostTableViewCell")
        self.tableView.tableFooterView = UIView()
//        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 63
        self.tableView.addSubview(self.refreshControl)
        
        loadPosts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadingIndicator.stopAnimating()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Due to iOS bug
        self.refreshControl.superview?.sendSubviewToBack(self.refreshControl)
    }
    
    func loadPosts() {
        
        if self.game == nil {
            let gameId = UserDefaultsManager.sharedInstance.getCurrentGameId()
            let gamePredicate = NSPredicate(format: "objectId == %@", gameId)
            let gamesFound = ObjectManager.sharedInstance.retrieveGames(withPredicate: gamePredicate)
            if gamesFound.count > 0 { self.game = gamesFound[0] }
        }
        
        if let currentGame = self.game {
            let predicate = NSPredicate(format: "game == %@", currentGame)
            self.allPosts = ObjectManager.sharedInstance.retrievePosts(withPredicate: predicate)
        }
    }
    
    func refreshPosts(sender: AnyObject) {
        if let currentGame = self.game {
            let predicate = NSPredicate(format: "gameId == %@", currentGame.objectId)
            ObjectManager.sharedInstance.downloadPosts(withPredicate: predicate, completionHandler: {
                (success: Bool) -> Void in
                // TODO: Error Checking
                let predicate = NSPredicate(format: "game == %@", currentGame)
                self.allPosts = ObjectManager.sharedInstance.retrievePosts(withPredicate: predicate)
                self.tableView.reloadData()
                dispatch_async(dispatch_get_main_queue(), {
                    self.refreshControl.endRefreshing()
                })
            })
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as! PostTableViewCell
        cell.game = self.game
        cell.post = self.allPosts[indexPath.row]
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
