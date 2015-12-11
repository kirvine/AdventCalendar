//
//  DaysTableViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/7/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DaysTableViewController: PFQueryTableViewController {

    var calendarString: String?
    var calendarObject: PFObject?
    
    @IBAction func viewAdventCalendar () {
        performSegueWithIdentifier("showAdvent", sender: calendarString!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }

    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Days")
        if let calString = calendarString {
            query.whereKey("calendarId", equalTo: calString)
        }
        
        query.orderByAscending("day")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! DayTableViewCell
    
        // fetch image & connect to labels
        if let imageFile = object?.objectForKey("image") as? PFFile {
            // image has been uploaded
            cell.giftImage.file = imageFile
            cell.giftImage.loadInBackground()
        } else {
            // no image present
            let placeholder = UIImage(named: "day_placeholder")
            cell.giftImage.image = placeholder
        }
        
        // fetch labels & connect to labels        
        let number = object?.objectForKey("day")
        cell.dayLabel.text = "Dec \(number!)"
        cell.noteLabel.text = object?.objectForKey("note") as? String
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDay" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // send selected day object to edit view
                let dayObject = self.objects?[indexPath.row] as? PFObject
                (segue.destinationViewController as! EditDayViewController).selectedObject = dayObject
            }
        } else if segue.identifier == "showAdvent" {
            // send calendar id to AdventCalendar view
            if let vc = segue.destinationViewController as? AdventCalendarViewController {
                vc.calendarId = sender as? String
            }
        } else if segue.identifier == "daysToEditCal" {
            if let vc = segue.destinationViewController as? NewCalendarViewController {
                vc.selectedObject = calendarObject
            }
        }
    }


    
    
}
