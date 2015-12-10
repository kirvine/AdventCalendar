//
//  CalendarsViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/3/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CalendarsTableViewController: PFQueryTableViewController {
    
    var calendars = [PFObject]()
    var calObject: PFObject?
    var calendarId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }
    
    override func queryForTable() -> PFQuery {
        if (PFUser.currentUser() == nil) {
            return PFQuery()
            
        } else {
            
            let creates = PFQuery(className: "Calendars")
            creates.whereKey("createdBy", equalTo: PFUser.currentUser()!.username!)
            
            let views = PFQuery(className: "Calendars")
            views.whereKey("viewedBy", equalTo: PFUser.currentUser()!.username!)
            
            let query = PFQuery.orQueryWithSubqueries([creates, views])
            query.orderByDescending("createdAt")
            
            return query
        }

    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CalendarTableViewCell
        
        // fetch image & connect to outlet
        if let imageFile = object?.objectForKey("image") as? PFFile {
            // image has been uploaded
            cell.cellImage.file = imageFile
            cell.cellImage.loadInBackground()
        } else {
            let placeholder = UIImage(named: "calendar_placeholder")
            cell.cellImage.image = placeholder
        }

        // fetch labels & connect to labels
        cell.titleLabel.text = object?.objectForKey("title") as? String
        cell.creatorLabel.text = object?.objectForKey("createdBy") as? String
        cell.yearLabel.text = object?.objectForKey("year") as? String
        
        calendars.append(object!)
        
        return cell
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row + 1 > self.objects?.count {
            return 44
        }
        // set row height to size defined in storyboard
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let username = PFUser.currentUser()?.objectForKey("username") as! String
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.calObject = self.objects?[indexPath.row] as? PFObject
            if let calObj = calObject {
                self.calendarId = calObject?.objectId
            }
            let createdBy = calObject?.objectForKey("createdBy") as! String
            
            if username == createdBy {
                performSegueWithIdentifier("calToDays", sender: self.calendarId)
            } else {
                performSegueWithIdentifier("calToAdvent", sender: nil)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  MARK:   Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calToDays" {
            if let vc = segue.destinationViewController as? DaysTableViewController {
                vc.calendarString = self.calendarId
                vc.calendarObject = self.calObject
            }
        } else if segue.identifier == "calToAdvent" {
            if let vc = segue.destinationViewController as? AdventCalendarViewController {
                vc.calendarId = self.calendarId
            }
        }
    }
    

}
