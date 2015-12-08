//
//  SearchTableViewDataSource.swift
//  Caster
//
//  Created by Josh Koch on 12/5/15.
//  Copyright © 2015 Josh Koch. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchTableViewDataSource: NSObject, UITableViewDataSource {
    
    var newArray: Array<String> = []
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 // This was put in mainly for my own unit testing
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newArray.count    //dataSourceArray.count
                    // Most of the time my data source is an array of something...  will replace with the actual name of the data source
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Note:  Be sure to replace the argument to dequeueReusableCellWithIdentifier with the actual identifier string!
        let cell = tableView.dequeueReusableCellWithIdentifier("ShowCell") as UITableViewCell!
        
        // set cell's textLabel.text property
        // set cell's detailTextLabel.text property
        return cell
    }
    
    // Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
