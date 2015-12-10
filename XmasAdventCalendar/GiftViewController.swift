//
//  GiftViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/9/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class GiftViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var giftImage: PFImageView!

    var dayObject: PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLabels() {
        if let object = dayObject {
            // set day label
            let number = object.objectForKey("day") as? Int
            self.dayLabel.text  = "Dec \(number!)"
            
            // set contents of note field
            if let value = object.objectForKey("note") as? String {
                self.noteLabel.text = value
            }
            
            // set image
            if let imageFile = object.objectForKey("image") as? PFFile {
                // image has been uploaded
                self.giftImage.file = imageFile
                self.giftImage.loadInBackground()
            } else {
                // no image present
                let placeholder = UIImage(named: "gift_placeholder")
                self.giftImage.image = placeholder
            }
        }

    }
    


    

}
