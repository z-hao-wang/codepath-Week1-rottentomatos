//
//  MovieDetailViewController.swift
//  
//
//  Created by Hao Wang on 2/6/15.
//
//

import UIKit

let NAV_BAR_HEIGHT: CGFloat = 64.0
let TEXT_BOTTOM_LIMIT: CGFloat = 100.0

class MovieDetailViewController: UIViewController {
    
    var data = NSDictionary()
    
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var descView: UIView!
    @IBOutlet var detailsView: UIView!
    
    var touchBeganLocation = CGPoint()
    var touchBeganY = CGFloat()
    
    func setImage() {
        var data = self.data
        if let posters = data["posters"] as? NSDictionary {
            if let thumbnail = posters["thumbnail"] as? String {
                if let backgroundImg = self.backgroundImg? {
                    Utils.setImageWithUrlFromThumbnailToLarge(thumbnail, imageView: backgroundImg, successCallback: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
        if let synopsis = data["synopsis"] as? String {
            descText.text = synopsis
        }
        if let title = data["title"] as? String {
            movieTitle.text = title
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch = event.allTouches()?.anyObject() as UITouch
        if touch.view == descView {
            touchBeganLocation = touch.locationInView(detailsView)
            touchBeganY = descView.frame.origin.y
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touch = event.allTouches()?.anyObject() as UITouch
        if touch.view == descView {
            println("touch count 1")
            var location = touch.locationInView(detailsView)
            var frame = descView.frame
            frame.origin.y = touchBeganY + location.y - touchBeganLocation.y
            //constrain the origin y to be in specific range
            if frame.origin.y < NAV_BAR_HEIGHT { //128 is nav bar height
                frame.origin.y =  NAV_BAR_HEIGHT
            }
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width;
            let screenHeight = screenSize.height;
            if frame.origin.y > screenHeight - TEXT_BOTTOM_LIMIT {
                frame.origin.y = screenHeight - TEXT_BOTTOM_LIMIT
            }
            descView.frame = frame
        }
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
