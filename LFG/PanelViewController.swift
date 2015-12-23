//
//  PanelViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-21.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

enum PanelOption: Int {
    case Games = 0
    case Feedback = 1
    case Donate = 2
    case Help = 3
}

protocol PanelDelegate {
    func userDidSelectPanelOption(option: PanelOption)
}

class PanelViewController: TableViewController {
    
    var content = [String]()
    var delegate: PanelDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.content = ["Games", "Feedback", "Donate", "Help"]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell!.textLabel?.text = self.content[indexPath.row]
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.delegate?.userDidSelectPanelOption(PanelOption(rawValue: indexPath.row)!)
    }
}
