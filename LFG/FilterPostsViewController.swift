//
//  FilterPostsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-18.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

protocol FilterPostsDelegate {
    func userSelectedOptions(options: [String: String?])
}

class FilterPostsViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var delegate: FilterPostsDelegate?
    
    var game: Game?
    
    var numberOfRowsInSection = [Int]()
    var selectedRowInSection = [Int]()
    var titleForSection = [String]()
    var sectionNameWithContent = [String: [String]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Filter Posts"
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        setUpContent()
    }
    
    // Currently, the user can only filter by platform and game type
    func setUpContent() {
        
        if let currentGame = game {
            
            if let platforms = currentGame.platforms.allObjects as? [Platform] where platforms.count > 1 {
                
                let platformStrings = currentGame.platformsAsStrings()
                self.titleForSection.append("Platforms")
                self.sectionNameWithContent["Platforms"] = platformStrings
                self.numberOfRowsInSection.append(platformStrings.count)
                
                // Find previously selected option (if applicable)
                if let platform = UserDefaultsManager.sharedInstance.getDefaultPlatformsFilterValue(),
                    rowNumber = platformStrings.indexOf(platform) {
                        self.selectedRowInSection.append(rowNumber)
                }
                else {
                    self.selectedRowInSection.append(-1)
                }
            }
            
            if let gameTypes = currentGame.gameTypes.allObjects as? [GameType] where gameTypes.count > 1 {
                
                let gameTypeStrings = currentGame.gameTypesAsStrings()
                self.titleForSection.append("Game Types")
                self.sectionNameWithContent["Game Types"] = gameTypeStrings
                self.numberOfRowsInSection.append(gameTypeStrings.count)
                
                // Find previously selected option (if applicable)
                if let gameType = UserDefaultsManager.sharedInstance.getDefaultGameTypesFilterValue(),
                    rowNumber = gameTypeStrings.indexOf(gameType) {
                        self.selectedRowInSection.append(rowNumber)
                }
                else {
                    self.selectedRowInSection.append(-1)
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleForSection[section]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.numberOfRowsInSection.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section < self.numberOfRowsInSection.count {
            return self.numberOfRowsInSection[section]
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") {
            
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            if let contentStrings = self.sectionNameWithContent[self.titleForSection[indexPath.section]] {
                cell.textLabel?.text = contentStrings[indexPath.row]
                if selectedRowInSection[indexPath.section] == indexPath.row {
                    cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if selectedRowInSection[indexPath.section] == indexPath.row {
            selectedRowInSection[indexPath.section] = -1
        } else {
            self.selectedRowInSection[indexPath.section] = indexPath.row
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    @IBAction func applyButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
        // Populate sectionNameWithSelection Inform delegate and save new userdefaults
    }
    
}
