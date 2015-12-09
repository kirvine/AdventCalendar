//
//  AdventCalendarViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/9/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AdventCalendarViewController: UIViewController, UIScrollViewDelegate {

    var calendarId: String? = ""
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var containerView = UIView()
    
    var buttonLocations = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // image
        imageView = UIImageView(image: UIImage(named: "advent"))
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        
        let button = UIButton.init(type: .System)
        button.frame = CGRectMake(150, 150, 50, 50)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
        button.setTitle("1", forState: UIControlState.Normal)
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        scrollView.addSubview(imageView)
        scrollView.addSubview(button)
        
        view.addSubview(scrollView)
        
        scrollView.delegate = self
    }
    
    func buttonAction(sender: UIButton!) {
        let dayNumber = sender.titleForState(.Normal)!
        let dayObject = getDayObject(dayNumber)
        
        if canOpen(dayObject) {
            performSegueWithIdentifier("showGift", sender: nil)
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //  MARK: Custom Functions
    func getDayObject(dayNumber: String) -> PFObject {
        var query = PFQuery(className: "Days")
        query.whereKey("calendarId", equalTo: calendarId!)
        query.whereKey("day", equalTo: dayNumber)
        print("*calendar: \(calendarId) day: \(dayNumber)")
        print(query)
        var obj = query.getFirstObject()!
        print(obj)
        return obj
    }
    
    
    func canOpen(object: PFObject?) -> Bool {
        // get day and year that gift should be opened
        let giftDay = object!.objectForKey("day") as? String
        let giftYear = object!.objectForKey("year") as? String
        
        // get current day and year
        let currentDay = getCurrentDate("d")
        let currentYear = getCurrentDate("Y")
        
        return (currentDay >= giftDay && currentYear >= giftYear)
    }
    
    func getCurrentDate(format: String) -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
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
