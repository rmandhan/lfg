//
//  AddPostViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-06.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

protocol AddPostDelegate {
    func userSubmittedPost()
}

class AddPostViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, OptionSelectedDelegate {
    
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var postBarButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: AddPostDelegate?
    
    var game: Game!
    var post: PseudoPost!
    var rowContent = [String]()
    var selectedIndexPath = NSIndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Submit a Post"
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        let nib = UINib(nibName: "PostDescTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PostDescTableViewCell")
        
        // Append post requirements in order
        self.rowContent.append("Platform")
        self.rowContent.append("Player Id")
        self.rowContent.append("Game Type")
        self.rowContent.append("Character")
        self.rowContent.append("Mic")
        if self.game.primaryLevelMax.integerValue > 0 { self.rowContent.append("Primary Level") }
        if self.game.secondaryLevelMax.integerValue > 0 { self.rowContent.append("Secondary Level") }
        self.rowContent.append("Description")
        
        post = PseudoPost(character: "", platform: "", desc: "", gameType: "", mic: false, playerId: "", primaryLevel: 0, secondaryLevel: 0, gameId: self.game.objectId)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name:UIKeyboardWillHideNotification, object: nil)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let content = rowContent[indexPath.row]
        
        var cell = UITableViewCell()
        
        // TODO: Need to understand dequeueReusableCellWithIdentifier more
//        let dequedCell = tableView.dequeueReusableCellWithIdentifier(content)
//        if dequedCell != nil {
//            cell = dequedCell!
//            return cell
//        }
        
        if content == "Platform" {
            
            cell = self.createDisclosureTypeCell(withIdentifier: content)
            
            if self.game.hasOnlyOnePlatform {
                cell.userInteractionEnabled = false
                cell.detailTextLabel?.text = self.game.firstPlatform()
            }
            else {
                cell.detailTextLabel?.text = post.platform
            }
        }
        else if content == "Game Type" {
            
            cell = self.createDisclosureTypeCell(withIdentifier: content)
            
            if self.game.hasOnlyOneGameType {
                cell.userInteractionEnabled = false
                cell.detailTextLabel?.text = self.game.firstGameType()
            }
            else {
                cell.detailTextLabel?.text = post.gameType
            }
        }
        else if content == "Character" {
            
            cell = self.createDisclosureTypeCell(withIdentifier: content)
            
            if self.game.hasOnlyOneCharacter {
                cell.userInteractionEnabled = false
                cell.detailTextLabel?.text = self.game.firstCharacter()
            }
            else {
                cell.detailTextLabel?.text = post.character
            }
        }
        else if content == "Player Id" {
            cell = self.createTextFieldCell(withIdentifier: content, withTag: 0, text: post.playerId, placeholder: "Id", keyboardType: UIKeyboardType.Default)
        }
        else if content == "Mic" {
            cell = self.createSwitchCell(withIdentifier: content, action: "switchValueChanged:", state: post.mic)
        }
        else if content == "Primary Level" {
            
            let placeholder = self.game.primaryLevelMin.stringValue + " - " + self.game.primaryLevelMax.stringValue
            
            if post.primaryLevel.integerValue != 0 {
                cell = self.createTextFieldCell(withIdentifier: content, withTag: 1, text: post.primaryLevel.stringValue, placeholder: placeholder, keyboardType: UIKeyboardType.NumbersAndPunctuation)
            } else {
                cell = self.createTextFieldCell(withIdentifier: content, withTag: 1, text: "", placeholder: placeholder, keyboardType: UIKeyboardType.NumbersAndPunctuation)
            }
        }
        else if content == "Secondary Level" {
           
            let placeholder = self.game.secondaryLevelMin.stringValue + " - " + self.game.secondaryLevelMax.stringValue
            
            if post.secondaryLevel.integerValue != 0 {
                cell = self.createTextFieldCell(withIdentifier: content, withTag: 2, text: post.secondaryLevel.stringValue, placeholder: placeholder, keyboardType: UIKeyboardType.NumbersAndPunctuation)
            } else {
                cell = self.createTextFieldCell(withIdentifier: content, withTag: 2, text: "", placeholder: placeholder, keyboardType: UIKeyboardType.NumbersAndPunctuation)
            }
        }
        // Custom Cell
        else if content == "Description" {
            
            if let postDescriptionCell = tableView.dequeueReusableCellWithIdentifier("PostDescTableViewCell") as?PostDescTableViewCell {
                postDescriptionCell.titleLabel.text = cellTitleFor(rowContent[indexPath.row])
                postDescriptionCell.descriptionTextView.text = self.post.desc
                postDescriptionCell.descriptionTextView.tag = 3
                postDescriptionCell.descriptionTextView.delegate = self
                return postDescriptionCell
            }
        }
        
        cell.textLabel?.text = cellTitleFor(rowContent[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedIndexPath = indexPath
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let content = rowContent[indexPath.row]
        
        if content == "Platform" || content == "Game Type" || content == "Character" {
            self.performSegueWithIdentifier("showOptionsVC", sender: self)
        }
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var textAfterUpdate: String = ""
        
        if textField.text == "" {
            textAfterUpdate = string
        } else {
            // TODO: Handle this safely?
            textAfterUpdate = (textField.text as! NSString).stringByReplacingCharactersInRange(range, withString: string)
        }
        
        // Player Id
        if textField.tag == 0 && textAfterUpdate != "" {
            if textAfterUpdate.characters.count > 16 {
                return false
            }
            post.playerId = textAfterUpdate
        }
            
        // Primary Level
        else if textField.tag == 1 {
            if let level = Int(textAfterUpdate) {
                if level > self.game.primaryLevelMax.integerValue || level < self.game.primaryLevelMin.integerValue {
                    return false
                }
                post.primaryLevel = level
            } else {
                if textAfterUpdate == "" {
                    post.primaryLevel = 0
                    return true
                }
                return false
            }
        }
            
        // Secondary Level
        else if textField.tag == 2 {
            if let level = Int(textAfterUpdate) {
                if level > self.game.secondaryLevelMax.integerValue || level < self.game.secondaryLevelMin.integerValue {
                    return false
                }
                post.secondaryLevel = level
            } else {
                if textAfterUpdate == "" {
                    post.secondaryLevel = 0
                    return true
                }
                return false
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        // Maybe there is a better way to handle this...
        var descRowNumber = 0
        
        if self.game.primaryLevelMax.integerValue > 0 && self.game.secondaryLevelMax.integerValue > 0 {
            descRowNumber = 7
        } else if self.game.primaryLevelMax.integerValue > 0 {
            descRowNumber = 6
        } else {
            descRowNumber = 5
        }
        
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: descRowNumber, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        var textAfterUpdate: String = ""
        
        if textView.text == "" {
            textAfterUpdate = text
        } else {
            // TODO: Handle this safely?
            textAfterUpdate = (textView.text as! NSString).stringByReplacingCharactersInRange(range, withString: text)
        }
        
        // Description
        if textView.tag == 3 {
            if textAfterUpdate.characters.count > 140 {
                return false
            }
        }
        
        self.post.desc = textAfterUpdate
        
        return true
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        
        var incompletePost: Bool = false
        
        if self.post.character.isEmpty || self.post.platform.isEmpty ||
            self.post.gameType.isEmpty || self.post.playerId.isEmpty {
            incompletePost = true
        }
        
        // > 0 condition is to check if there is even a primary or secondary level in the game
        if (self.game.primaryLevelMax.integerValue > 0 && self.post.primaryLevel.integerValue < self.game.primaryLevelMin.integerValue) ||
            (self.game.secondaryLevelMax.integerValue  > 0 && self.post.secondaryLevel.integerValue  < self.game.secondaryLevelMin.integerValue) {
            incompletePost = true
        }
        
        if incompletePost {
            let alert = UIAlertView()
            alert.title = "Failed to Post"
            alert.message = "Please check all the mandatory fields and try again"
            alert.addButtonWithTitle("OK")
            alert.show()
        }
        // Upload Post
        else {
            // TODO: Display a uploading screen or indicator
            ObjectManager.sharedInstance.uploadPost(self.post, completionHandler: {
                (success: Bool) -> Void in
                if success {
                    self.dismissViewControllerAnimated(true, completion: {
                        self.delegate?.userSubmittedPost()
                    })
                }
            })
        }
    }
    
    // UISwitch Action
    
    func switchValueChanged(mySwitch: UISwitch) {
        self.post.mic = mySwitch.on
    }
    
    // MARK: OptionSelectedDelegate
    
    func userSelectedOption(option: String) {
        
        let selectedContent = self.rowContent[selectedIndexPath.row]
        
        if selectedContent == "Platform" {
            self.post.platform = option
        }
        else if selectedContent == "Game Type" {
            self.post.gameType = option
        }
        else if selectedContent == "Character" {
            self.post.character = option
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showOptionsVC" {
            
            let selectedContent = self.rowContent[selectedIndexPath.row]
            
            let optionsVC = segue.destinationViewController as! OptionsViewController
            optionsVC.delegate = self
            optionsVC.pageTitle = selectedContent
            
            if selectedContent == "Platform" {
                optionsVC.optionsList = self.game.platformsAsStrings()
            }
            else if selectedContent == "Game Type" {
                optionsVC.optionsList = self.game.gameTypesAsStrings()
            }
            else if selectedContent == "Character" {
                optionsVC.optionsList = self.game.charactersAsStrings()
            }
        }
    }
    
    // MARK: Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        keyboardFrame = self.view.convertRect(keyboardFrame, fromView: nil)

        self.tableView.contentInset.bottom = keyboardFrame.size.height
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentInset.bottom = 0
    }
    
    // MARK: Helper Methods
    
    func cellTitleFor(content: String) -> String? {
        
        var title = String?()
        
        switch(content) {
            
        case "Platform":
            title = "Platform"
            
        case "Player Id":
            title = "Player Id"
            
        case "Game Type":
            title = "Game Type"
            
        case "Character":
            title = "Character"
            
        case "Mic":
            title = "Mic"
            
        case "Primary Level":
            title = self.game.primaryLevelName
            
        case "Secondary Level":
            title = self.game.secondaryLevelName
            
        case "Description":
            title = "Description"
            
        default:
            title = nil
        }
        
        return title
    }
    
    func createDisclosureTypeCell(withIdentifier identifier: String) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func createTextFieldCell(withIdentifier identifier: String, withTag tag: Int, text: String, placeholder: String, keyboardType: UIKeyboardType) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        let theTextField = UITextField(frame: CGRectMake(0, 0, 160, 35))
        theTextField.tag = tag
        theTextField.text = text
        theTextField.keyboardType = keyboardType
        theTextField.backgroundColor = UIColor.whiteColor()
        theTextField.textAlignment = NSTextAlignment.Right
        theTextField.placeholder = placeholder
        theTextField.textColor = UIColor.blackColor()
        theTextField.layer.cornerRadius = 10.0
        theTextField.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        theTextField.delegate = self
        cell.accessoryView = theTextField
        return cell
    }
    
    func createSwitchCell(withIdentifier identifier: String, action: Selector, state: Bool) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        
        let accessorySwitch = UISwitch()
        accessorySwitch.on = state
        accessorySwitch.addTarget(self, action: action, forControlEvents: UIControlEvents.ValueChanged)
        cell.accessoryView = accessorySwitch
        return cell
    }
    
}
