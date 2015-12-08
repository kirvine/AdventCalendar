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
    
    override func queryForTable() -> PFQuery {
        
        let query = PFQuery(className: "Days")
        query.whereKey("calendarId", equalTo: self.calendarString!)
        query.orderByAscending("date")
        
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
            let placeholder = UIImage(named: "present")
            cell.giftImage.image = placeholder
        }
        
        // fetch labels
        let date = object?.objectForKey("date")
        let stringDate = formatDateLabel(date as! NSDate)
        cell.dayLabel.text = stringDate
        cell.noteLabel.text = object?.objectForKey("note") as? String
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDay" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // send selected day object to edit view
                let dayObject = self.objects?[indexPath.row] as? PFObject
                (segue.destinationViewController as! EditDayViewController).selectedObject = dayObject
                
            }
            
        }
    }
    
    //  MARK: Custom Functions
    
    func formatDateLabel(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let stringDate = dateFormatter.stringFromDate(date)
        return stringDate
    }
    

}
