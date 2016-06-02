//
//  mswb_WordDetailsTblViewCtrl.swift
//  MWSGDuolingo
//
//  Created by Mikhail Zoline on 31/03/16.
//  Copyright © 2016 Duolingo. All rights reserved.
//

import UIKit

class mswb_WordDetailsTblViewCtrl: UITableViewController {

    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appDelegate.wordLocations.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordNames", forIndexPath: indexPath)

        // Configure the cell...
        
        let words = [String](appDelegate.wordLocations.keys)

        let word = words[indexPath.row]
        cell.textLabel?.text = "\(word)"
        
        
        if appDelegate.allFoundedWords.contains(word)
        {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None

        }
        return cell
    }

    
    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), 50))
            
        headerView.backgroundColor = UIColor(red:143/255.0, green:178/255.0, blue: 255/255.0, alpha:1.0)

        
        let label = UILabel(frame:CGRectMake(10, 0, CGRectGetWidth(headerView.frame),CGRectGetHeight(headerView.frame)))
        
        label.textAlignment = NSTextAlignment.Left
        label.font = UIFont(name: "HelveticaNeue-neue", size: 14)
        label.textColor = UIColor.blackColor()
        
        headerView.addSubview(label)
    
        label.text =  appDelegate.sourceWord
            
        
        return headerView
        
    }
}
