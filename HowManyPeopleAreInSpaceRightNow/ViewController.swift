//
//  ViewController.swift
//  HowManyPeopleAreInSpaceRightNow
//
//  Created by Sam Agnew on 5/2/16.
//  Copyright © 2016 Sam Agnew. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    @IBOutlet var pictureOfTheDayOutlet: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let dateString = getYesterdayDateString()
        Alamofire.request(.GET, "https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos", parameters: ["api_key": "DEMO_KEY", "earth_date": dateString])
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let result = response.result.value {
                    let json = JSON(result)
                    if let imageUrl = json["photos"][0]["img_src"].string {
                        self.load_image(imageUrl.stringByReplacingOccurrencesOfString("http", withString: "https"))
                    }
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    self.pictureOfTheDayOutlet.image = UIImage(data: data!)
                }
        })
        
    }
    
    func getYesterdayDateString() -> String {
        let calendar = NSCalendar.currentCalendar()
        let yesterday = calendar.dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        let components = calendar.components([.Day , .Month , .Year], fromDate: yesterday!)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        return "\(year)-\(month)-\(day)"
    }


}