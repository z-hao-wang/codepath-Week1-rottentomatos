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

class ListTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var errorView: UIView!
    
    var filterText = ""
    
    var filteredMovies = NSArray()
    
    let apikey = "ya5m8hg2zbz48gu98gwr3brs"
    
    let boxOfficeURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json"
    let theatersURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json"
    let openingURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/opening.json"
    let upcomingURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/upcoming.json"
    
    
    var theatersData = NSArray()
    var upcomingData = NSArray()
    var upcomingDataFiltered = NSArray()
    var theatersDataFiltered = NSArray()
    
    var thearterDataLoaded = false
    var upcomingDataLoaded = false
    
    //Send URL request to retrive json data. Call success or fail callback
    func loadJson(url: String, success: (NSArray) -> (), fail: () -> ()) {
        let urlWithKey = NSURL(string: url + "?apikey=" + self.apikey)!
        var request = NSURLRequest(URL: urlWithKey)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if (data == nil) {
                //Display error message here
                println(error)
                fail()
            } else {
                var responseDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                if let moviesList = responseDictionary["movies"] as? NSArray {
                    success(moviesList)
                }
            }
            
        }
    }
    
    func onRefresh() {
        self.loadData()
    }
    
    func loadData() {
        var stepsLoaded = 0
        let urls = [self.theatersURL, self.upcomingURL]
        SVProgressHUD.show()
        for idx in 0..<urls.count {
            loadJson(urls[idx], {moviesList in //success
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
                    self.applyFilter()
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    self.refreshControl?.endRefreshing()
                    self.toggleNetworkError(false) //hide network error
                }
                println("steps" + String(stepsLoaded))
            }, { //fail
                if ++stepsLoaded == urls.count {
                    //loading done
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                    self.refreshControl?.endRefreshing()
                    let currentRect = self.errorView.frame.integerRect
                    self.toggleNetworkError(true)
                }
            })
        }
    }
    
    //Seach filter apply
    func filterContentForSearchText(data: NSArray, searchText: String) -> NSArray {
        // Filter the array using the filter method
        if countElements(searchText) == 0 {
            return data
        }
        let toFilter = data as Array;
        var filteredMovies = toFilter.filter({( movie: AnyObject) -> Bool in
            if let m = movie as? NSDictionary {
                if let title = m["title"] as? String {
                    let stringMatch = title.rangeOfString(searchText, options: .CaseInsensitiveSearch)
                    return stringMatch != nil
                }
            }
            return false
        })
        return filteredMovies
    }
    
    func applyFilter() {
        self.upcomingDataFiltered = filterContentForSearchText(self.upcomingData, searchText: self.filterText)
        self.theatersDataFiltered = filterContentForSearchText(self.theatersData, searchText: self.filterText)
    }
    
    //Search bar text change event. update filter
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        NSLog("Search Bat Text Changed \(searchText)")
        filterText = searchText
        applyFilter()
        self.tableView.reloadData()
    }
    
    func getDataByIndexPath(indexPath: NSIndexPath) -> NSDictionary {
        switch indexPath.section {
        case UPCOMING:
            return self.upcomingDataFiltered[indexPath.row] as NSDictionary
        case IN_THEATER:
            return self.theatersDataFiltered[indexPath.row] as NSDictionary
        default:
            return self.theatersDataFiltered[indexPath.row] as NSDictionary
        }
    }
    
    func toggleNetworkError(show: Bool) {
        self.view.bringSubviewToFront(errorView)
        self.errorView.frame.origin.y -= self.errorView.frame.size.height //set to top of original position
        UIView.animateWithDuration(0.7, delay: 0.0, options: .CurveEaseOut, animations: {
            var errorFrame = self.errorView.frame
            errorFrame.origin.y += errorFrame.size.height //animate to original position
            self.errorView.frame = errorFrame
        }, completion: { finished in
                println("animation done!")
        })
        errorView.hidden = !show
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleNetworkError(false)
        //self.view.addSubview(errorView)
        loadData()        //Add pull refresh controll
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.view.insertSubview(refreshControl!, atIndex: 0)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.rowHeight = 120 //fix row height
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
                return self.upcomingDataFiltered.count > MAX_UPCOMING ? MAX_UPCOMING : self.upcomingDataFiltered.count
            case IN_THEATER:
                return self.theatersDataFiltered.count > MAX_IN_THEATERS ? MAX_IN_THEATERS : self.theatersDataFiltered.count
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case UPCOMING:
                return "Coming Soon"
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
            if let critics_score = ratings["critics_score"] as? Int {
                cell.labelScore1?.text = String(critics_score)
            }
            if let audience_score = ratings["audience_score"] as? Int {
                cell.labelScore2?.text = String(audience_score)
            }
        }
        if let synopsis = data["synopsis"] as? String {
            cell.labelDesc?.text = synopsis
        }
        if let posters = data["posters"] as? NSDictionary {
            if let thumbnail = posters["thumbnail"] as? String {
                //first load thumnnail
                let thumbnailURL = NSURL(string: thumbnail)!
                cell.movieImage?.setImageWithURLRequest(NSURLRequest(URL: thumbnailURL), placeholderImage: nil, success: { (a, b, imageTmb) -> Void in
                    //Set image transition
                    UIView.transitionWithView(cell.movieImage!, duration: 0.5, options: .TransitionCrossDissolve, animations: {
                        cell.movieImage?.image = imageTmb
                        return
                    }, completion: nil)
                    //load original image, use thumbnail image as placeholder
                    let originalImgURL = thumbnail.stringByReplacingOccurrencesOfString("tmb.jpg", withString: "ori.jpg")
                    cell.movieImage?.setImageWithURL(NSURL(string: originalImgURL), placeholderImage: imageTmb)
                }, failure: { (a, b, c) -> Void in
                    println(a)
                })
                
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
