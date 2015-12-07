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

    // fetch calendar objects
    override func queryForTable() -> PFQuery {
        if (PFUser.currentUser() == nil) {
            return PFQuery()
        } else {
            var creates = PFQuery(className: "Calendars")
            creates.whereKey("createdBy", equalTo: PFUser.currentUser()!.username!)
            
            var views = PFQuery(className: "Calendars")
            views.whereKey("viewedBy", equalTo: PFUser.currentUser()!.username!)
            
            var query = PFQuery.orQueryWithSubqueries([creates, views])
            query.orderByDescending("createdAt")
            return query
        }

    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CalendarTableViewCell
        
        // fetch image
        var placeholder = UIImage(named: "merryxmas")
        cell.cellImage.image = placeholder
        if let imageFile = object?.objectForKey("image") as? PFFile {
            cell.cellImage.file = imageFile
            cell.cellImage.loadInBackground()
        }

        // fetch labels
//        cell.titleLabel.text = object?.objectForKey("createdAt") as? String
        cell.titleLabel.text = object?.objectForKey("title") as? String
        cell.creatorLabel.text = object?.objectForKey("createdBy") as? String
        
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

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row + 1 > self.objects?.count {
            self.loadNextPage()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            self.performSegueWithIdentifier("editCalendar", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loadObjects()
    }

}
