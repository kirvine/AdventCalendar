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

    var selectedObject: PFObject?
    var calendarString: String?
    
    override func queryForTable() -> PFQuery {
        print("*running queryForTable")
        let query = PFQuery(className: "Days")
        query.whereKey("calendarId", equalTo: self.calendarString!)
        query.orderByAscending("date")
        print("---\(self.calendarString)")
        return query
    }
    
//    func userDidSelectCalendar(id: String) {
//        self.calendarString = id
//    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("dayCell", forIndexPath: indexPath) as! DayTableViewCell
    
        // fetch image
        let placeholder = UIImage(named: "present")
        cell.giftImage.image = placeholder
        if let imageFile = object?.objectForKey("image") as? PFFile {
            cell.giftImage.file = imageFile
            cell.giftImage.loadInBackground()
        }
        
        // fetch labels
        let date = object?.objectForKey("date")
        let stringDate = formatDateLabel(date as! NSDate)
        cell.dayLabel.text = stringDate
        cell.noteLabel.text = object?.objectForKey("note") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = self.objects?[indexPath.row] as? PFObject
        selectedObject = object!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("*running viewDidLoad")

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
