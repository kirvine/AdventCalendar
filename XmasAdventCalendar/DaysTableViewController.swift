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

    var queryKey: String? = ""
    var selectedObject: PFObject?
    
    override func queryForTable() -> PFQuery {
        print("running queryForTable")
        var query = PFQuery(className: "Days")
        query.whereKey("calendarId", equalTo: self.queryKey!)
        query.orderByAscending("date")
        print("query:\(query.countObjects())")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! DayTableViewCell
    
        // fetch image
        var placeholder = UIImage(named: "present")
        cell.giftImage.image = placeholder
        if let imageFile = object?.objectForKey("image") as? PFFile {
            cell.giftImage.file = imageFile
            cell.giftImage.loadInBackground()
        }
        
        // fetch labels
        var date = object?.objectForKey("date")
        var stringDate = formatDateLabel(date as! NSDate)
        cell.dayLabel.text = stringDate
        cell.noteLabel.text = object?.objectForKey("note") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var object = self.objects?[indexPath.row] as? PFObject
        selectedObject = object!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("running viewDidLoad")
        
//        dispatch_async(dispatch_get_main_queue(), {
//            self.queryForTable()
//            
//            // only for demo purposes; forecast retrieved too fast normally
//            sleep(2)
//            var i = 0
//            repeat { i += 1 } while self.queryForTable().countObjects() == 0
//            
//            // update labels as soon as data is retrieved
//            self.tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?)
//        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDay" {
            let dayEditor: EditDayViewController = segue.destinationViewController as! EditDayViewController
            dayEditor.selectedObject = self.selectedObject
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
