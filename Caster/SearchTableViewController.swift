//
//  SearchTableViewController.swift
//  Caster
//
//  Created by Josh Koch on 12/5/15.
//  Copyright © 2015 Josh Koch. All rights reserved.
//

 /// Description

import UIKit
import SwiftyJSON
import Alamofire
import Kingfisher
import DZNEmptyDataSet
import ChameleonFramework

class SearchTableViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var podcasts:[Show] = []
    let imageView: UIImageView = UIImageView()
    
    
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
    
    /*deinit {
        self.tableView.emptyDataSetDelegate = nil
        self.tableView.emptyDataSetSource = nil
    }
    */
    // MARK: - Table view data source
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
        cell.showImage.kf_setImageWithURL(podcasts[indexPath.row].showImage!)
        
        return cell
    }
    
    // MARK: - Navigation
    
    let podcastSegueIndentifier = "ShowPodcastSegue"
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == podcastSegueIndentifier {
            if let destination = segue.destinationViewController as? PodcastViewController {
                if let showIndex = tableView.indexPathForSelectedRow?.row {
                    destination.podcastTitle = podcasts[showIndex].title!
                    destination.feedUrl = podcasts[showIndex].feedUrl!
                }
            }
        }
    }
}

extension SearchTableViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No podcasts present")
    }
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "Try searching for a show above")
    }
}