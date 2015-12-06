//
//  NewCalendarViewController.swift
//  XmasAdventCalendar
//
//  source: https://medium.com/swift-programming/ios-swift-parse-com-part-3-sign-up-sign-in-sign-out-security-349adc94ef0e#.pjyiltqwb
//  Created by Karen on 12/5/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NewCalendarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Calendar object to create
    var newObject : PFObject?
    
    // Calendar object to create
    var currentObject : PFObject?
    
    // Image Picker object
    var imagePicker = UIImagePickerController()
    var imageDidChange = false

    @IBOutlet weak var calendarImage: PFImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!

    
    
    
    //  MARK:   Actions
    
    // Prompt user to allow permission to device photo library
    @IBAction func uploadImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }

    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        newObject = PFObject(className:"Calendars")
        
        // Update the object
        if let newCalendar = newObject {
            
            if let title = titleField.text?.isEmpty {
                
                let alertMsg = UIAlertController(title: "Error", message: "Calendar must have a title", preferredStyle: UIAlertControllerStyle.Alert)
                alertMsg.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMsg, animated: true, completion: nil)
                
            } else {
                
                newCalendar["title"] = titleField.text
                newCalendar["createdBy"] = PFUser.currentUser()?.username
                
                // Upload any flag image
                if imageDidChange == true {
                    
                    let imageData = UIImagePNGRepresentation(calendarImage.image!)
                    let fileName = titleField.text! + ".png"
                    let imageFile = PFFile(name:fileName, data: imageData!)
                    newCalendar["image"] = imageFile
                    
                }
                
                // Save the data back to the server in a background task
                newCalendar.saveInBackground()
            }

        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //  MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial labels and fields
        calendarImage.image = UIImage(named: "merryxmas")
        yearLabel.text = getCurrentYear()
        createdByLabel.text = PFUser.currentUser()?.username
        
        }

    
    //  MARK:   Custom Functions
    
    // Process selected image - add image to the parse object model
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Update the image within the app interface
            calendarImage.image = pickedImage
            calendarImage.contentMode = .ScaleAspectFit
            
            // Update the image did change flag so that we pick this up when the country is ssaved back to Parse
            imageDidChange = true
        }
        
        // Dismiss the image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func getCurrentYear() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Y"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }


}
