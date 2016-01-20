//
//  PostsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-21.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class PostsViewController: TableViewController, UIPopoverPresentationControllerDelegate, AddPostDelegate, FilterPostsDelegate {
    
    @IBOutlet var panelBarButton: UIBarButtonItem!
    @IBOutlet var filterBarButton: UIBarButtonItem!
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    var game: Game?
    var allPosts = [Post]()
    var filteredPosts = [Post]()
    var selectedPost: Post?
    
    var filterHeaderText = "Displaying all posts"
    var displayingFilteredPosts = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Posts"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let postCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        self.tableView.registerNib(postCellNib, forCellReuseIdentifier: "PostTableViewCell")
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84
        
        self.refreshControl?.addTarget(self, action: "refreshTriggered", forControlEvents: UIControlEvents.ValueChanged)
        
        self.loadPosts()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchNewPosts(forceDownload: false)
    }
    
    func loadPosts() {
        if let currentGame = self.game {
            self.allPosts = currentGame.recentPostsSortedByDate()
            self.filteredPosts = currentGame.applyDefaultFiltersToPosts(self.allPosts)
            self.displayingFilteredPosts = self.filteredPosts.count != self.allPosts.count
            self.filterBarButton.enabled = self.allPosts.count != 0
        }
    }
    
    func fetchNewPosts(forceDownload forceDownload: Bool) {
        
        if self.allPosts.count == 0 {
            self.loadingIndicator.startAnimating()
        }
        
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
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingIndicator.stopAnimating()
                })
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.displayingFilteredPosts {
            return "Displaying filtered posts"
        } else {
            return "Displaying all posts"
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.displayingFilteredPosts {
            return self.filteredPosts.count
        } else {
            return self.allPosts.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostTableViewCell") as? PostTableViewCell {
            
            cell.game = self.game
            
            if self.displayingFilteredPosts {
                cell.post = self.filteredPosts[indexPath.row]
            } else {
                cell.post = self.allPosts[indexPath.row]
            }
            
            if cell.post?.deviceId == UIDevice.currentDevice().identifierForVendor?.UUIDString {
                cell.userInteractionEnabled = true
            } else {
                cell.userInteractionEnabled = false
            }
            
            cell.render()
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.displayingFilteredPosts {
            self.selectedPost = self.filteredPosts[indexPath.row]
        } else {
            self.selectedPost = self.allPosts[indexPath.row]
        }
        
        self.presentPostOptions()
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    // MARK: AddPostDelegate
    
    func userSubmittedPost() {
        // TODO: This is not the best solution. Improve this in the future.
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
        
        if self.filteredPosts.count > 0 {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: true)
        }
    }
    
    // MARK: Actions

    @IBAction func addBarButtonTapped(sender: AnyObject) {
        if let postDate = UserDefaultsManager.sharedInstance.getLastPostDate() {
            if !postDate.isOlderThanFiveMinutes {
                self.presentNewPostTimeAlert()
                return
            }
        }
        
        self.performSegueWithIdentifier("presentAddNewPostView", sender: self)
    }
    
    @IBAction func panelBarButtonTapped(sender: AnyObject) {
        if let mainNVC = self.navigationController as? MainNavigationController {
            mainNVC.togglePanel()
        }
    }
    
    // Called when a cell is selected
    
    func presentPostOptions() {
        
        let optionMenu = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
             (alert: UIAlertAction!) -> Void in
            
            if let id = self.selectedPost?.objectId {
                ObjectManager.sharedInstance.deletePostForId(id, completionHandler: {
                    (success: Bool) -> Void in
                    // TODO: Error Handling
                    if success {
                        // Is it bad to do this? Do I need weakSelf? Or something else?
                        self.fetchNewPosts(forceDownload: true)
                    }
                })
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // Called by UIRefreshControl
    func refreshTriggered() {
        self.fetchNewPosts(forceDownload: false)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "presentAddNewPostView" {
            let nvc = segue.destinationViewController as! UINavigationController
            if let addNewPostVC = nvc.topViewController as? AddNewPostViewController {
                addNewPostVC.delegate = self
                addNewPostVC.game = self.game
            }
        }
        else if segue.identifier == "showFilterPopover" {
            self.changeBarButtonsState(enabled: false)
            let nvc = segue.destinationViewController as! UINavigationController
            if let filterPostsVC = nvc.topViewController as? FilterPostsViewController,
                popoverController = nvc.popoverPresentationController  {
                    filterPostsVC.delegate = self
                    filterPostsVC.game = self.game
                    popoverController.delegate = self
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
        self.panelBarButton.enabled = enabled
        self.addBarButton.enabled = enabled
    }
    
    func presentNewPostTimeAlert() {
        let alert = UIAlertView()
        alert.title = "Unable to Post"
        alert.message = "Please wait at least 5 minutes before posting again"
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
}
