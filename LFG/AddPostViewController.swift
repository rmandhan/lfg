//
//  AddPostViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

class AddPostViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var postBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var game: Game!
    
    var rowContent = [String]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Submit a Post"
        self.tableView.tableFooterView = UIView()
        
        // Append post requirements in order
        self.rowContent.append("Console")
        self.rowContent.append("Player Id")
        self.rowContent.append("Game Type")
        self.rowContent.append("Character")
        self.rowContent.append("Mic")
        
        if game.primaryLevelMax.intValue > 0 { self.rowContent.append("Primary Level") }
        if game.secondaryLevelMax.intValue > 0 { self.rowContent.append("Secondary Level") }
        
        self.rowContent.append("Description")
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let content = rowContent[indexPath.row]
        
        var cell = UITableViewCell()
        
        let dequedCell = tableView.dequeueReusableCellWithIdentifier(content)
        
        if dequedCell != nil {
            cell = dequedCell!
        } else {
            if content == "Console" {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: content)
            } else if content == "Player Id" {
                
            } else if content == "Game Type" {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: content)
            } else if content == "Character" {
                cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: content)
            } else if content == "Mic" {
                
            } else if content == "Primary Level" {
                let accessoryButton = UITextField()
                var theTextField = UITextField(frame: CGRectMake(0, 0, 100, 35))
                theTextField.backgroundColor = UIColor.whiteColor()
                theTextField.placeholder = "Please type here...."
                theTextField.textColor = UIColor.blackColor()
                theTextField.layer.cornerRadius = 10.0
               // theTextField.delegate = self
                cell.accessoryView = theTextField
             //   cell.accessoryView?.hidden = true
            } else if content == "Secondary Level" {
                
            } else if content == "Desecription" {
                
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        cell.textLabel?.text = cellTitleFor(rowContent[indexPath.row])
        cell.detailTextLabel?.text = "Sample"
        
        return cell
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Helper Methods
    
    func cellTitleFor(content: String) -> String? {
        
        var title = String?()
        
        switch(content) {
            
        case "Console":
            title = "Console"
            
        case "Player Id":
            title = "Player Id"
            
        case "Game Type":
            title = "Game Type"
            
        case "Character":
            title = "Character"
            
        case "Mic":
            title = "Mic"
            
        case "Primary Level":
            if game.isBlackOps3 {
                title = "Prestige"
            } else if game.isDestiny {
                title = "Level"
            }
            
        case "Secondary Level":
            if game.isBlackOps3 {
                title = "Level"
            } else if game.isDestiny {
                title = "Light Level"
            }
            
        case "Description":
            title = "Description"
            
        default:
            title = nil
        }
        
        return title
    }
}
