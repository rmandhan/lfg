//
//  OptionsViewController.swift
//  LFG
//
//  Created by Rakesh Mandhan on 2015-12-07.
//  Copyright © 2015 Rakesh. All rights reserved.
//

import UIKit

protocol OptionSelectedDelegate {
    func userSelectedOption(option: String)
}

class OptionsViewController: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: OptionSelectedDelegate?
    
    var pageTitle: String = ""
    var optionsList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = pageTitle
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        cell?.textLabel?.text = optionsList[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.delegate?.userSelectedOption(optionsList[indexPath.row])
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}