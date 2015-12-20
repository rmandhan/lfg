//
//  FilterPostsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-18.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

enum sectionTitle: String {
    case platforms = "Platforms"
    case gameTypes = "Game Types"
}

protocol FilterPostsDelegate {
    func userSelectedFilterOptions(options: [String: String])
}

class FilterPostsViewController: ViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var applyBarButton: UIBarButtonItem!      // Text changes to "Show All" when nothing is selected
    @IBOutlet var resetBarButton: UIBarButtonItem!
    
    var delegate: FilterPostsDelegate?
    
    var game: Game?
    
    var numberOfRowsInSection = [Int]()
    var selectedRowInSection = [Int]()
    var titleForSection = [String]()
    var sectionNameWithContent = [String: [String]]()
    var sectionNameWithSelection = [String: String]()
    
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
                self.titleForSection.append(sectionTitle.platforms.rawValue)
                self.sectionNameWithContent[sectionTitle.platforms.rawValue] = platformStrings
                self.numberOfRowsInSection.append(platformStrings.count)
                
                // Find previously selected option (if applicable)
                if let platform = UserDefaultsManager.sharedInstance.getDefaultPlatformsFilterValue(),
                    rowNumber = platformStrings.indexOf(platform) {
                        self.selectedRowInSection.append(rowNumber)
                        self.sectionNameWithSelection[sectionTitle.platforms.rawValue] = platformStrings[rowNumber]
                }
                else {
                    self.selectedRowInSection.append(-1)
                }
            }
            
            if let gameTypes = currentGame.gameTypes.allObjects as? [GameType] where gameTypes.count > 1 {
                
                let gameTypeStrings = currentGame.gameTypesAsStrings()
                self.titleForSection.append(sectionTitle.gameTypes.rawValue)
                self.sectionNameWithContent[sectionTitle.gameTypes.rawValue] = gameTypeStrings
                self.numberOfRowsInSection.append(gameTypeStrings.count)
                
                // Find previously selected option (if applicable)
                if let gameType = UserDefaultsManager.sharedInstance.getDefaultGameTypesFilterValue(),
                    rowNumber = gameTypeStrings.indexOf(gameType) {
                        self.selectedRowInSection.append(rowNumber)
                        self.sectionNameWithSelection[sectionTitle.gameTypes.rawValue] = gameTypeStrings[rowNumber]
                }
                else {
                    self.selectedRowInSection.append(-1)
                }
            }
        }
        
        self.updateResetBarButtonState()
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
        return 30
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if self.selectedRowInSection[indexPath.section] == indexPath.row {
            self.selectedRowInSection[indexPath.section] = -1
            self.sectionNameWithSelection.removeValueForKey(self.titleForSection[indexPath.section])
        }
        else {
            self.selectedRowInSection[indexPath.section] = indexPath.row
            let sectionTitle = self.titleForSection[indexPath.section]
            if let sectionContent = self.sectionNameWithContent[sectionTitle] {
                self.sectionNameWithSelection[sectionTitle] = sectionContent[indexPath.row]
            }
        }
        
        self.updateResetBarButtonState()
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.None)
    }
    
    // MARK: Actions
    
    @IBAction func resetBarButton(sender: AnyObject) {
        // Deselect all rows if any are selected
        for var i = 0; i < self.selectedRowInSection.count; i++ {
            self.selectedRowInSection[i] = -1
        }
        self.sectionNameWithSelection.removeAll()
        self.tableView.reloadData()
        self.resetBarButton.enabled = false
    }
    
    @IBAction func applyButtonTapped(sender: AnyObject) {
        
        // Set user defaults
        let platform = sectionNameWithSelection[sectionTitle.platforms.rawValue]
        let gameType = sectionNameWithSelection[sectionTitle.gameTypes.rawValue]
        UserDefaultsManager.sharedInstance.setDefaultPlatformsFilterValue(platform)
        UserDefaultsManager.sharedInstance.setDefaultGameTypesFilterValue(gameType)
        
        self.delegate?.userSelectedFilterOptions(self.sectionNameWithSelection)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Helper Methods
    
    func updateResetBarButtonState() {
        
        var optionSelected = false
        
        for rowNumber in self.selectedRowInSection {
            if rowNumber != -1 {
                optionSelected = true
                break
            }
        }
        
        self.resetBarButton.enabled = optionSelected
    }
}
