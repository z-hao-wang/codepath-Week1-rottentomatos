//
//  ListTableViewController.swift
//  rottenTomato
//
//  Created by Hao Wang on 2/5/15.
//  Copyright (c) 2015 Hao Wang. All rights reserved.
//

import UIKit

let UPCOMING = 0
let IN_THEATER = 1
let MAX_UPCOMING = 3
let MAX_IN_THEATERS = 10

class ListTableViewController: UITableViewController {
    
    let apikey = "ya5m8hg2zbz48gu98gwr3brs"
    
    let boxOfficeURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json"
    let theatersURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json"
    let openingURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json"
    let upcomingURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json"
    
    
    var theatersData = NSArray()
    var upcomingData = NSArray()
    
    var thearterDataLoaded = false
    var upcomingDataLoaded = false
    
    func loadJson(url: String, task: (NSArray) -> ()) {
        
        let urlWithKey = NSURL(string: url + "?apikey=" + self.apikey)!
        var request = NSURLRequest(URL: urlWithKey)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (data == nil) {
                //Display error message here
                println(error)
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                if let moviesList = responseDictionary["movies"] as? NSArray {
                    task(moviesList)
                }
            }
        }
    }
    
    func loadData() {
        var stepsLoaded = 0
        let urls = [self.theatersURL, self.upcomingURL]
        for idx in 0..<urls.count {
            loadJson(urls[idx], {moviesList in
                switch idx {
                case 0:
                    self.upcomingData = moviesList
                case 1:
                    self.theatersData = moviesList
                default:
                    break
                }
                if ++stepsLoaded == urls.count {
                    //loading done
                    SVProgressHUD.dismiss()
                    self.tableView.reloadData()
                }
                println("steps" + String(stepsLoaded))
            })
        }
    }
    
    func getDataByIndexPath(indexPath: NSIndexPath) -> NSDictionary {
        switch indexPath.section {
        case UPCOMING:
            return self.upcomingData[indexPath.row] as NSDictionary
        case IN_THEATER:
            return self.theatersData[indexPath.row] as NSDictionary
        default:
            return self.theatersData[indexPath.row] as NSDictionary
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.rowHeight = 120
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch section {
            case UPCOMING:
                return self.upcomingData.count > MAX_UPCOMING ? MAX_UPCOMING : self.upcomingData.count
            case IN_THEATER:
                return self.theatersData.count > MAX_IN_THEATERS ? MAX_IN_THEATERS : self.theatersData.count
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case UPCOMING:
                return "Coming"
            case IN_THEATER:
                return "In Theater"
            default:
                return ""
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Did tap row \(indexPath.row)")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.rottenTomatos.listCell") as ListTableViewCell
        var data = self.getDataByIndexPath(indexPath)

        cell.labelTitle?.text = data["title"] as? String
        if let ratings = data["ratings"] as? NSDictionary {
            if let audience_score = ratings["audience_score"] as? Int {
                cell.labelDesc?.text = String(audience_score)
            }
        }
        if let posters = data["posters"] as? NSDictionary {
            if let thumbnail = posters["thumbnail"] as? String {
                //get original image url
                let originalImgURL = thumbnail.stringByReplacingOccurrencesOfString("tmb.jpg", withString: "ori.jpg")
                cell.movieImage?.setImageWithURL(NSURL(string: originalImgURL))
            }
        }
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
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
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var detailsViewController = segue.destinationViewController as MovieDetailViewController
        if let indexPath = tableView.indexPathForCell(sender as UITableViewCell) {
            var data = self.getDataByIndexPath(indexPath)
            detailsViewController.data = data
        }
    }

}
