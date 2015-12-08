//
//  SearchTableViewController.swift
//  Caster
//
//  Created by Josh Koch on 12/5/15.
//  Copyright © 2015 Josh Koch. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import DZNEmptyDataSet

class SearchTableViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var podcasts:[Show] = []
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        podcasts.removeAll()
        var text = searchBar.text
        text = text?.stringByReplacingOccurrencesOfString(" ", withString: "+")
        let url = NSURL(string: "https://itunes.apple.com/search?media=podcast&limit=25&term=".stringByAppendingString(text!))
        Alamofire.request(.GET, url!).responseJSON() { response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                for (_, show):(String, JSON) in json["results"] {
                    let title = show["collectionName"].stringValue
                    let author = show["artistName"].stringValue
                    let showImage = show["artworkUrl100"].URL
                    let feedUrl = show["feedUrl"].URL
                    let podcast = Show(title: title, author: author, showImage: showImage, feedUrl: feedUrl)
                    self.podcasts.append(podcast)
                }
                self.tableView.reloadData()
            case .Failure(let error):
                //TODO: Show user that search request has failed
                print("Request failed with error: \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        self.searchBar.sizeToFit()
        self.tableView.tableFooterView = UIView()
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.estimatedRowHeight = 200
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.tableView.emptyDataSetDelegate = nil
        self.tableView.emptyDataSetSource = nil
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section for results
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.podcasts.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ShowCell") as! ShowTableViewCell
        
        cell.titleLabel?.text = self.podcasts[indexPath.row].title
        cell.authorLabel?.text = self.podcasts[indexPath.row].author
        
        return cell
    }

    // Override to support editing the table view.

    // MARK: - Table view data source


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No podcasts present")
    }
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Try searching for a show above")
    }
}
