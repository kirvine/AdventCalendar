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

class AdventCalendarViewController: UIViewController, UIScrollViewDelegate, UIAlertViewDelegate {

    var calendarId: String? = ""
    
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var containerView = UIView()
    var bounds = CGRect()
    
//    var buttonLocations = [(150, 150), (450, 250), (750, 350), (450, 450), (150, 550), (450, 650), (750, 750), (450, 850), (150, 950), (450, 1100), (750, 1250), (450, 1400), (150, 1550), (450, 1700), (750, 1850)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("*advent vdl \(calendarId)")
        setScrollImage()
        placeButtons()
        
        
        view.addSubview(scrollView)
        
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        let bounds = scrollView.frame
        print("*\(bounds)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        bounds = view.bounds
    }
    
    func buttonLocationsArray() ->  [(Int, Int)] {
        let width = bounds.width
        let height = bounds.height
        
        print("*width =  \(width) height = \(height)")
        
        let xSpacing = Int(width/3)
        let ySpacing = Int(height/3)
        
        let x1 = xSpacing/2
        let x2 = x1 + xSpacing
        let x3 = x1 + (2*xSpacing)
        
        let y1 = ySpacing/2
        
        // hard code in where last y will be
        let y2 = y1 + (8*ySpacing)
        
        var buttons: [(Int, Int)] = []
        
        var x: Int
        var y: Int
        
        for col in 1...8 {
            y = y1 + (col*ySpacing)
            
            for row in 1...3 {
                if (row == 1) {
                    x = x1
                } else if (row == 2) {
                    x = x2
                } else {
                    x = x3
                }

                
                buttons.append((x, y))
            }
            
            // place 25th button
            x = x2+50
            y = y2 + 50
            buttons.append((x, y))
            
        }
        
        return buttons
        
    }
    
//    func buttonLocationsArray() ->  [(Int, Int)] {
//        let width = bounds.width
//        let height = bounds.height
//        
//        print("*width =  \(width) height = \(height)")
//        
//        let xSpacing = Int(width/3)
//        let ySpacing = Int(height/3)
//        
//        let x1 = xSpacing/2
//        let x2 = x1 + xSpacing
//        let x3 = x1 + (2*xSpacing)
//        
//        let y1 = ySpacing/2
//        
//        // hard code in where last y will be
//        let y2 = y1 + (8*ySpacing)
//        
//        var buttons: [(Int, Int)] = []
//        
//        var x: Int
//        var y: Int
//        
//        for row in 1...3 {
//            if (row == 1) {
//                x = x1
//            } else if (row == 2) {
//                x = x2
//            } else {
//                x = x3
//            }
//            for col in 1...8 {
//                y = y1 + (col*ySpacing)
//                
//                buttons.append((x, y))
//            }
//            
//            // place 25th button
//            x = x2+50
//            y = y2 + 50
//            buttons.append((x, y))
//
//        }
//
//        return buttons
//        
//    }
    
    
    func placeButtons() {
        var buttonLocations = buttonLocationsArray()
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
        print("*button actions \(calendarId)")
        let dayNumber = Int(sender.titleForState(.Normal)!)
        let dayObject = getDayObject(dayNumber!)
                
        if canOpen(dayObject) {
            performSegueWithIdentifier("showGift", sender: dayObject)
        } else {
            let alertView = UIAlertView(title: "No peeking 😝", message: "It isn't time to open this gift yet!", delegate: self, cancelButtonTitle: "OK")
            alertView.alertViewStyle = .Default
            alertView.show()
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
        print("*can open\(calendarId)")
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
                print("* in showGift segue sending: \(sender!) calendarId: \(calendarId!)")
                vc.dayObject = sender as? PFObject
            }
        }
    }

    
    
    
}
