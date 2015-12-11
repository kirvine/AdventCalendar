//
//  GiftViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/9/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class GiftViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var giftImage: PFImageView!

    var dayObject: PFObject?
    var calendarId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("*gift vdl")
        updateLabels()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        print("* in update labels dayObject \(dayObject)")
        if let object = dayObject {
            
            // set day label
            let number = object.objectForKey("day") as? Int
            self.dayLabel.text  = "Dec \(number!)"
            
            // note label
            self.noteLabel.text = object.objectForKey("note") as? String
            
            // set image
            let placeholder = UIImage(named: "gift_placeholder")
            self.giftImage.image = placeholder
            
            self.giftImage.file = object.objectForKey("image") as? PFFile
            self.giftImage.loadInBackground()
            
        } else {
            print("* in gift vc no dayObject")
            print("* calendarId: \(calendarId)")
        }

    }
    
    // MARK:    Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? AdventCalendarViewController {
            vc.calendarId = dayObject?.objectForKey("calendarId") as! String
        }
    }
    


    

}
