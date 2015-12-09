//
//  AdventDayViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/9/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class AdventDayViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var giftImage: PFImageView!

    var dayObject: PFObject?
    
    
    @IBAction func returnToAdventCalendar(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        
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
