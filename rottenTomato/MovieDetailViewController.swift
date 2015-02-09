//
//  MovieDetailViewController.swift
//  
//
//  Created by Hao Wang on 2/6/15.
//
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    var data = NSDictionary()
    
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var movieTitle: UILabel!
    
    func setImage() {
        var data = self.data
        if let posters = data["posters"] as? NSDictionary {
            if let thumbnail = posters["thumbnail"] as? String {
                //get original image url
                let originalImgURL = thumbnail.stringByReplacingOccurrencesOfString("tmb.jpg", withString: "ori.jpg")
                self.backgroundImg?.setImageWithURL(NSURL(string: originalImgURL))
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
