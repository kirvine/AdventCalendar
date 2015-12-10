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
    
    var buttonLocations = [(150, 150), (450, 450)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setScrollImage()
        placeButtons()
        
        
        view.addSubview(scrollView)
        
        scrollView.delegate = self
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
    
    //  Setup scroll view
    
    func setScrollImage() {
        imageView = UIImageView(image: UIImage(named: "advent"))
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        scrollView.addSubview(imageView)
    }
    
    func placeButtons() {
        var num = 1
        for (x, y) in buttonLocations {
            
            // initalize button
            let button = UIButton.init(type: .System)
            
            // set size and location
            let w = CGFloat(x)
            let z = CGFloat(y)
            
            button.frame = CGRectMake(w, z, 80, 80)
            
            // set backgroung and borders
            button.layer.cornerRadius = 5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.backgroundColor = UIColor.clearColor()
            
            // set title to number of day
            button.setTitle("\(num)", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            
            // set action
            button.addTarget(self, action: "openGift:", forControlEvents: UIControlEvents.TouchUpInside)
            
            // add button to scroll view
            scrollView.addSubview(button)
            
            // increment day number
            num += 1
            
        }
    }
    
    
    //  Button Actions
    func openGift(sender: UIButton!) {
        let dayNumber = Int(sender.titleForState(.Normal)!)
        let dayObject = getDayObject(dayNumber!)
        
        print("*in openGift dayNumber: \(dayNumber) dayObject: \(dayObject)")
        
        if canOpen(dayObject) {
            performSegueWithIdentifier("showGift", sender: dayObject)
        }
    }
    
    func getDayObject(dayNumber: Int) -> PFObject {
        var query = PFQuery(className: "Days")
        query.whereKey("calendarId", equalTo: calendarId!)
        query.whereKey("day", equalTo: dayNumber)
        var obj = query.getFirstObject()!
        return obj
    }
    
    func canOpen(object: PFObject?) -> Bool {
        // get day and year that gift should be opened
        let giftDay = object!.objectForKey("day") as? Int
        let giftYear = object!.objectForKey("year") as? Int
        
        // get current day and year
        let currentDay = getCurrentDate("d")
        let currentYear = getCurrentDate("Y")
        
        return (currentDay >= giftDay && currentYear >= giftYear)
    }
    
    func getCurrentDate(format: String) -> Int {
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
    
        var dateAsNum = Int(dateFormatter.stringFromDate(currentDate))
        return dateAsNum!
    }

    
    // MARK:    Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGift" {
            if let vc = segue.destinationViewController as? GiftViewController {
                print("* in showGift segue sending: \(sender!) calendarId: \(calendarId)")
                vc.dayObject = sender as? PFObject
            }
        }
    }

    
    
    
}
