//
//  PodcastViewController.swift
//  Caster
//
//  Created by Josh Koch on 12/8/15.
//  Copyright © 2015 Josh Koch. All rights reserved.
//

import UIKit
import ChameleonFramework
import Alamofire
import SWXMLHash

class PodcastViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var podcastTitleLabel: UILabel!
    @IBOutlet weak var podcastDescriptionLabel: UILabel!
    @IBOutlet weak var podcastImage: UIImageView!
    @IBOutlet weak var episodeTableView: UITableView!
    
    var podcastTitle = String()
    var feedUrl = NSURL()
    var selectedImage: UIImage!
    var episodes:[Episode] = []
    
    override func viewWillAppear(animated: Bool) {
        podcastTitleLabel.text = podcastTitle
        podcastImage.layer.borderWidth = 1
        podcastImage.layer.masksToBounds = false
        podcastImage.layer.borderColor = UIColor.flatGrayColor().CGColor
        podcastImage.layer.cornerRadius = podcastImage.frame.size.height / 2
        podcastImage.clipsToBounds = true
        podcastImage.image = selectedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Alamofire.request(.GET, feedUrl).responseData { response in
            switch response.result {
            case .Success(let data):
                let xml = SWXMLHash.parse(data)
                let podcastDesc = xml["rss"]["channel"]["description"].element?.text
                for elem in xml["rss"]["channel"]["item"] {
                    let episodeTitle = elem["title"].element?.text
                    let episodeSummary = elem["description"].element?.text
                    let episodeDuration = elem["itunes:duration"].element?.text
                    let episodeDate = elem["pubDate"].element?.text
                    let episodeUrl = elem["enclosure"].element?.attributes["url"]
                    let episode = Episode(episodeTitle: episodeTitle, episodeSummary: episodeSummary, episodeDuration: episodeDuration, episodeDate: episodeDate, episodeUrl: episodeUrl)
                    self.episodes.append(episode)
                }
                self.podcastDescriptionLabel.text = podcastDesc
                self.episodeTableView.reloadData()
            case .Failure(let error):
                //TODO: Show user that search request has failed
                print("Request failed with error: \(error)")
            }
        }
        
        configureTableView()
    }

    func configureTableView() {
        episodeTableView.rowHeight = UITableViewAutomaticDimension
        episodeTableView.estimatedRowHeight = 120.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 //Only one section for results
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.episodes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EpisodeCell") as! EpisodeTableViewCell
        let description:NSString? = self.episodes[indexPath.row].episodeSummary
        
        cell.epTitleLabel.text = self.episodes[indexPath.row].episodeTitle
        cell.epTitleLabel.textColor = ContrastColorOf(view.backgroundColor!, returnFlat: true)
        
        if let description = description {
            if description.length > 300 {
                cell.epDescriptionLabel.text = "\(description.substringToIndex(300))..."
            } else {
                cell.epDescriptionLabel.text = description as String
            }
        }
        
        cell.epDescriptionLabel.textColor = ContrastColorOf(view.backgroundColor!, returnFlat: true)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
