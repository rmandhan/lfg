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
    
    var numberOfRows = 8
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.title = "Submit a Post"
        self.tableView.tableFooterView = UIView()
        
        if game.primaryLevelMax == 0 { self.numberOfRows-- }
        if game.secondaryLevelMax == 0 { self.numberOfRows-- }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        return cell!
    }
    
    // MARK: Actions
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
