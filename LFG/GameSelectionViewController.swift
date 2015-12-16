//
//  GameSelectionViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-05.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class GameSelectionViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
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
        
        if self.gamesList.count == 0 {
            self.loadingIndicator.startAnimating()
        }
        
        // TEMPORARY: CHANGE AFTER TESTING
        ObjectManager.sharedInstance.downloadGames(withPredicate: nil, completionHandler: {
            (success: Bool) -> Void in
            if success {
                
                self.gamesList = ObjectManager.sharedInstance.retrieveGames()
                self.tableView.reloadData()
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadingIndicator.stopAnimating()
                })
            }
        })
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        //        cell.contentView.backgroundColor = UIColor.clearColor()
        //
        //        let whiteRoundedView : UIView = UIView(frame: CGRectMake(0, 10, self.view.frame.size.width, 70))
        //
        //        whiteRoundedView.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [1.0, 1.0, 1.0, 1.0])
        //        whiteRoundedView.layer.masksToBounds = false
        //        whiteRoundedView.layer.cornerRadius = 2.0
        //        whiteRoundedView.layer.shadowOffset = CGSizeMake(-1, 1)
        //        whiteRoundedView.layer.shadowOpacity = 0
        //
        //        cell.contentView.addSubview(whiteRoundedView)
        //        cell.contentView.sendSubviewToBack(whiteRoundedView)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gamesList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let game = gamesList[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("GameTableViewCell") as! GameTableViewCell
        cell.gameObjectId = game.objectId
        cell.gameName.text = game.fullName
        cell.render()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedPath = indexPath
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! GameTableViewCell
        cell.cellSelected()
        self.performSegueWithIdentifier("goToPostsViewController", sender: self)
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "goToPostsViewController" {
            let postsViewController = segue.destinationViewController as! PostsViewController
            postsViewController.game = gamesList[self.selectedPath.row]
        }
    }
}