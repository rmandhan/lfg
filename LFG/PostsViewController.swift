//
//  PostsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostsViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, AddPostDelegate, FilterPostsDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var listBarButton: UIBarButtonItem!
    @IBOutlet var filterBarButton: UIBarButtonItem!
    @IBOutlet var addBarButton: UIBarButtonItem!

    lazy var refreshControl = UIRefreshControl()
    
    var game: Game?
    var allPosts = [Post]()
    var filteredPosts = [Post]()
    var filterHeaderText = "Displaying all posts"
    var displayingFilteredPosts = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Posts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "")
        self.refreshControl.addTarget(self, action: "refreshTriggered", forControlEvents: UIControlEvents.ValueChanged)
        
        let postCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.registerNib(postCellNib, forCellReuseIdentifier: "PostTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 63
        self.tableView.addSubview(self.refreshControl)
        self.tableView.sendSubviewToBack(self.refreshControl)
        
        loadPosts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.allPosts.count == 0 {
            self.loadingIndicator.startAnimating()
        }
        
        fetchNewPosts(forceDownload: false)
    }
    
    // NOTE: Remove if not used
//    override func viewWillLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        // Due to iOS bug
//        self.refreshControl.superview?.sendSubviewToBack(self.refreshControl)
//    }
    
    func loadPosts() {
        if let currentGame = self.game {
            self.allPosts = currentGame.recentPostsSortedByDate()
            self.filteredPosts = currentGame.applyDefaultFiltersToPosts(self.allPosts)
            self.displayingFilteredPosts = self.filteredPosts.count != self.allPosts.count
            self.filterBarButton.enabled = self.allPosts.count != 0
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.displayingFilteredPosts {
            return "Displaying filtered posts"
        } else {
            return "Displaying all posts"
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayingFilteredPosts {
            return self.filteredPosts.count
        } else {
            return self.allPosts.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as? PostTableViewCell {
            
            cell.game = self.game
            
            if self.displayingFilteredPosts {
                cell.post = self.filteredPosts[indexPath.row]
            } else {
                cell.post = self.allPosts[indexPath.row]
            }
            
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: AddPostDelegate
    
    func userSubmittedPost() {
        self.fetchNewPosts(forceDownload: true)
    }

    // MARK: FilterPostsDelegate
    
    func userSelectedFilterOptions(options: [String : String]) {
        
        self.changeBarButtonsState(enabled: true)
        
        var postsWereFiltered = false
        
        self.filteredPosts = self.allPosts
        
        if let platform = options[sectionTitle.platforms.rawValue] {
            self.filteredPosts = self.filteredPosts.filter({ $0.platform == platform })
            postsWereFiltered = true
        }
        
        if let gameType = options[sectionTitle.gameTypes.rawValue] {
            self.filteredPosts = self.filteredPosts.filter({ $0.gameType == gameType })
            postsWereFiltered = true
        }
        
        self.displayingFilteredPosts = postsWereFiltered
        
        self.tableView.reloadData()
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func addBarButtonTapped(sender: AnyObject) {
        
    }
    
    @IBAction func filterBarButtonTapped(sender: AnyObject) {
        self.changeBarButtonsState(enabled: false)
        self.performSegueWithIdentifier("showFilterPostsVC", sender: self)
    }
    
    // TEMP: Takes user back to the Games list
    @IBAction func sideBarButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Called by UIRefreshControl
    func refreshTriggered() {
        self.fetchNewPosts(forceDownload: false)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showAddPostVC" {
            let nvc = segue.destinationViewController as! UINavigationController
            if let addPostViewConroller = nvc.topViewController as? AddPostViewController {
                addPostViewConroller.delegate = self
                addPostViewConroller.game = self.game
            }
        }
        else if segue.identifier == "showFilterPostsVC" {
            let nvc = segue.destinationViewController as! UINavigationController
            if let filterPostsViewController = nvc.topViewController as? FilterPostsViewController,
                popoverVC = nvc.popoverPresentationController  {
                filterPostsViewController.delegate = self
                filterPostsViewController.game = self.game
                popoverVC.delegate = self
            }
        }
    }
    
    // MARK: UIAdaptivePresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        self.changeBarButtonsState(enabled: true)
    }
    
    // MARK: Helper Methods
    
    // Excludes filter bar button
    func changeBarButtonsState(enabled enabled: Bool) {
        self.listBarButton.enabled = enabled
        self.addBarButton.enabled = enabled
    }
    
}
