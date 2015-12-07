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

    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Days")
        query.whereKey("calendarId", equalTo: "GpuZjBE6wc")
        query.orderByAscending("date")
        return query
    
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! DayTableViewCell
        
        // fetch image
        var placeholder = UIImage(named: "present")
        cell.giftImage.image = placeholder
        if let imageFile = object?.objectForKey("image") as? PFFile {
            cell.giftImage.file = imageFile
            cell.giftImage.loadInBackground()
        }
        
        // fetch labels
        var date = object?.objectForKey("date") as? NSDate
        var stringDate = formatDateLabel(date!)
        cell.dayLabel.text = stringDate
        cell.noteLabel.text = object?.objectForKey("note") as? String
        
        return cell
    }

    func formatDateLabel(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE d"
        let stringDate = dateFormatter.stringFromDate(date)
        return stringDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
