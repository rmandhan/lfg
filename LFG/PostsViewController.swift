//
//  PostsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostsViewController: ViewController, UITableViewDelegate, UITableViewDataSource, AddPostDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var filterBarButton: UIBarButtonItem!
    
    lazy var refreshControl = UIRefreshControl()
    
    var game: Game?
    var allPosts = [Post]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Posts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refreshTriggered", forControlEvents: UIControlEvents.ValueChanged)
        
        let postCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.registerNib(postCellNib, forCellReuseIdentifier: "PostTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 63
        self.tableView.addSubview(self.refreshControl)
        
        if let currentGame = self.game {
            self.filterBarButton.enabled = currentGame.postsCanBeFiltered
        }
        
        loadPosts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.allPosts.count == 0 {
            self.loadingIndicator.startAnimating()
        }
        
        fetchNewPosts(forceDownload: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Due to iOS bug
        self.refreshControl.superview?.sendSubviewToBack(self.refreshControl)
    }
    
    func loadPosts() {
        if let currentGame = self.game {
            self.allPosts = currentGame.recentPostsSortedByDate()
        }
    }
    
    func fetchNewPosts(forceDownload forceDownload: Bool) {
        
        if let currentGame = self.game {
            
            let downloadPostsDate = UserDefaultsManager.sharedInstance.getLastUpdatedPostsDate(forGame: currentGame.objectId)
            let timeElapsed = NSDate().timeIntervalSinceDate(downloadPostsDate)
            
            if forceDownload || timeElapsed > 15 {
                
                ObjectManager.sharedInstance.downloadPosts(currentGame.objectId, withPredicate: nil,  completionHandler: {
                    (success: Bool) -> Void in
                    
                    // TODO: Error Checking
                    if success {
                        self.loadPosts()
                        self.tableView.reloadData()
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.loadingIndicator.stopAnimating()
                    })
                })
            }
            else {
                self.loadingIndicator.stopAnimating()
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as? PostTableViewCell {
            cell.game = self.game
            cell.post = self.allPosts[indexPath.row]
            cell.render()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! PostTableViewCell
            cell.cellSelected()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    // MARK: AddPostDelegate
    
    func userSubmittedPost() {
        self.fetchNewPosts(forceDownload: true)
    }

    // MARK: Actions
    
    @IBAction func addBarButtonTapped(sender: AnyObject) {
        
    }
    
    // TEMP: Takes user back to the Games list
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func filterButtonTapped(sender: AnyObject) {
    }
    
    // Called by UIRefreshControl
    func refreshTriggered() {
        self.fetchNewPosts(forceDownload: false)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToAddPostViewController" {
            let nvc = segue.destinationViewController as! UINavigationController
            if let addPostViewConroller = nvc.topViewController as? AddPostViewController {
                addPostViewConroller.delegate = self
                addPostViewConroller.game = self.game
            }
        }
        else if segue.identifier == "goToFilterPostsViewController" {
            let nvc = segue.destinationViewController as! UINavigationController
            if let filterPostsViewController = nvc.topViewController as? FilterPostsViewController {
                // filterPostsViewController.delegate = self
                filterPostsViewController.game = self.game
            }
        }
    }
    
}
