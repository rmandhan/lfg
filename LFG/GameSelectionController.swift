//
//  GameSelectionController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-21.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class GameSelectionController: TableViewController {
    
//    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var gamesList = [Game]()
    var selectedPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Games"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let nib = UINib(nibName: "GameTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "GameTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let gamesWereDownloaded = UserDefaultsManager.sharedInstance.getGamesDownloadedState()
        
        if self.gamesList.count == 0 {
//            self.loadingIndicator.startAnimating()
        }
        
        if !gamesWereDownloaded || self.gamesList.count == 0  {
            ObjectManager.sharedInstance.downloadGames(withPredicate: nil, completionHandler: {
                (success: Bool) -> Void in
                if success {
                    
                    self.gamesList = ObjectManager.sharedInstance.retrieveGames()
                    self.tableView.reloadData()
                    
                    dispatch_async(dispatch_get_main_queue(), {
//                        self.loadingIndicator.stopAnimating()
                    })
                }
            })
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let game = gamesList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("GameTableViewCell") as! GameTableViewCell
        cell.gameObjectId = game.objectId
        cell.gameName.text = game.fullName
        cell.render()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPath = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        UserDefaultsManager.sharedInstance.setCurrentGameId(self.gamesList[indexPath.row].objectId)
        self.performSegueWithIdentifier("showPostsView", sender: self)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPostsView" {
            let postsVC = segue.destinationViewController as! PostsViewController
            postsVC.game = gamesList[self.selectedPath.row]
        }
    }

}
