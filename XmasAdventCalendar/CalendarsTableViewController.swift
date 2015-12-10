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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  MARK:   Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let username = PFUser.currentUser()?.objectForKey("username") as! String
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let calObject = self.objects?[indexPath.row] as? PFObject
            let createdBy = calObject?.objectForKey("createdBy") as! String
            print("*username: \(username) createdBy: \(createdBy)")
            
            if username == createdBy {
                if segue.identifier == "calToDays" {
                    print("*is creator")
                    if let vc = segue.destinationViewController as? DaysTableViewController {
                        vc.calendarString = calObject?.objectId
                        vc.calendarObject = calObject
                    }
                }
            } else {
                print("*not creator trying \(calObject?.objectId)")
                if segue.identifier == "calToAdvent" {
                    if let vc = segue.destinationViewController as? AdventCalendarViewController {
                        vc.calendarId = calObject?.objectId
                        ("*sent \(calObject?.objectId)")
                    }
                }
            }
        }
    }
    
    func viewDaysSegueData() {
        
    }
    

    
    //  MARK:   Delete functions
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var object = objectAtIndexPath(indexPath)
            object?.deleteInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    self.loadObjects()
                } else {
                    // There was a problem, check error.description
                }
            }
//        }
    }
    
    
    

}
