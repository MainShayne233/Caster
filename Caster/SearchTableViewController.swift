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
import MaterialKit

class SearchTableViewController: UIViewController, UISearchBarDelegate, UISearchResultsUpdating, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var podcasts:[Show] = []
    var searchController: UISearchController!
    var gradientScheme = [FlatNavyBlueDark(), FlatWhite()]
    var colorArray = ColorSchemeOf(ColorScheme.Complementary, color: FlatBlueDark(), isFlatScheme: true)
    let imageView: UIImageView = UIImageView()
    var textField: MKTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //configureSearchBar()
        configureTextField()
        self.tableView.tableFooterView = UIView()
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.navigationController!.hidesNavigationBarHairline = true
        //self.view.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: gradientScheme)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        self.tableView.emptyDataSetDelegate = nil
        self.tableView.emptyDataSetSource = nil
    }
    
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
        cell.titleLabel.textColor = colorArray[2]
        
        cell.authorLabel?.text = self.podcasts[indexPath.row].author
        
        cell.showImage.layer.borderWidth = 1
        cell.showImage.layer.masksToBounds = false
        cell.showImage.layer.borderColor = UIColor.flatGrayColor().CGColor
        cell.showImage.layer.cornerRadius = cell.showImage.frame.size.height / 2
        cell.showImage.clipsToBounds = true
        cell.showImage.kf_setImageWithURL(podcasts[indexPath.row].showImage!)
        
        return cell
    }
    
    //MARK: - SearchBar
    /*
    func configureCustomSearchController() {
        searchController = PodcastSearchController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, tableView.frame.size.width, 50.0), searchBarFont: UIFont.systemFontOfSize(16), searchBarTextColor: FlatWhite(), searchBarTintColor: UIColor.clearColor())
        
        searchController.customSearchBar.placeholder = "Search for podcasts here..."
        navigationItem.titleView = searchController.customSearchBar
    }
    */
    
    func configureTextField() {
        textField = MKTextField(frame: view.frame)
        textField.backgroundColor = FlatWhite()
        textField.placeholder = "Search for podcasts here..."
        textField.rippleLocation = .Left
        textField.floatingPlaceholderEnabled = false
        textField.layer.borderColor = FlatWhite().CGColor
        textField.rippleLayerColor = FlatBlue()

        self.navigationItem.titleView = textField
    }
    
    func configureSearchBar() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundColor = UIColor.clearColor()
        searchController.searchBar.showsCancelButton = false

        // Place the search bar view to the tableview headerview.
        self.navigationItem.titleView = searchController.searchBar
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        podcasts.removeAll()
        var text = searchController.searchBar.text
        if text?.characters.count > 2 {
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
        } else {
            self.tableView.reloadData()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.searchController.searchBar.endEditing(true)
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
                    
                    let index = NSIndexPath(forRow: showIndex, inSection: 0)
                    let cell = self.tableView.cellForRowAtIndexPath(index) as! ShowTableViewCell
                    
                    destination.selectedImage = cell.showImage.image!
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