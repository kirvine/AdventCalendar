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
        print("*cal table vdl")
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("*didSelect")
        let username = PFUser.currentUser()?.objectForKey("username") as! String
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            self.calObject = self.objects?[indexPath.row] as? PFObject
            self.calendarId = calObject?.objectId
            let createdBy = calObject?.objectForKey("createdBy") as! String
            print("*did select username: \(username) createdBy: \(createdBy)")
            print("*did select calendarId: \(calendarId) calObject: \(calObject)")
            
            if username == createdBy {
                print("*is days")
                performSegueWithIdentifier("calToDays", sender: nil)
            } else {
                print("*is advent")
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
            print("*in calToDays segue")
            if let vc = segue.destinationViewController as? DaysTableViewController {
                vc.calendarString = self.calendarId
                vc.calendarObject = self.calObject
                print("*in calToDays segue calendarString: \(vc.calendarString) day: \(vc.calendarObject)")
            }
        } else if segue.identifier == "calToAdvent" {
            print("*is advent")
            if let vc = segue.destinationViewController as? AdventCalendarViewController {
                print("*is advent segue")
                vc.calendarId = self.calendarId
                print("*is advent segue sending \(self.calendarId)")
            }
        }
    }
    
    
    //  MARK:   Delete functions
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//
////        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            var object = objectAtIndexPath(indexPath)
//            object?.deleteInBackgroundWithBlock {
//                (success: Bool, error: NSError?) -> Void in
//                if (success) {
//                    self.loadObjects()
//                } else {
//                    // There was a problem, check error.description
//                }
//            }
//        }
//    }
    
    
    

}
