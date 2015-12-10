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

class NewCalendarViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Calendar object to create
    var newObject : PFObject?
    
    // Image Picker object
    var imagePicker = UIImagePickerController()
    var imageDidChange = false

    @IBOutlet weak var calendarImage: PFImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var viewersField: UITextField!

    
    //  MARK:   Actions
    
    // Prompt user to allow permission to device photo library
    @IBAction func uploadImage(sender: AnyObject) {
       
        let optionMenu = createImageUploadMenu()
        self.presentViewController(optionMenu, animated: true, completion: nil)
    
    }
    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        // Create new object
        newObject = PFObject(className:"Calendars")
        
        // Update the object
        if let newCalendar = newObject {
            
            if titleField.text == "" {
                
                let alertMsg = UIAlertController(title: "Error", message: "Calendar must have a title", preferredStyle: UIAlertControllerStyle.Alert)
                alertMsg.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMsg, animated: true, completion: nil)
                
            } else {
                
                newCalendar["title"] = titleField.text
                newCalendar["createdBy"] = PFUser.currentUser()?.username
                
                // Upload image
                if imageDidChange == true {
                    
                    let imageData = UIImagePNGRepresentation(calendarImage.image!)
                    let fileName = titleField.text! + ".png"
                    let imageFile = PFFile(name:fileName, data: imageData!)
                    newCalendar["image"] = imageFile
                    
                }
                
                // Save the data back to the server in a background task
                newCalendar.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved. Now make 25 days
                        if let id = newCalendar.objectId {
                            self.createDays(id)
                        }
                    }
                }
            }

        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    //  MARK: Override Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        titleField.delegate = self
        
        // set initial labels and fields
        updateLabels()
        
        }

    
    
    //  MARK:   UIImagePicker Functions
    
    // Process selected image & add back to parse object
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            // Update the image within the app interface
            calendarImage.image = pickedImage
            calendarImage.contentMode = .ScaleAspectFit
            
            imageDidChange = true
        }
        
        // Dismiss the image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // make popup menu for image upload options
    func createImageUploadMenu() -> UIAlertController {
        let optionMenu = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .ActionSheet)
        
        let photoLibraryOption = UIAlertAction(title: "Photo Library", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            //shows the photo library
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            self.imagePicker.modalPresentationStyle = .Popover
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let cameraOption = UIAlertAction(title: "Camera", style: .Default, handler: { (alert: UIAlertAction!) -> Void in
            //shows the camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .Camera
            self.imagePicker.modalPresentationStyle = .Popover
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
            
        })
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
        // add options to alert
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            optionMenu.addAction(cameraOption)
        }
        optionMenu.addAction(photoLibraryOption)
        optionMenu.addAction(cancelOption)
        
        return optionMenu
    }

    
    // MARK:    UITextField Delegate
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    //  MARK:   Custom Functions

    func updateLabels() {
        calendarImage.image = UIImage(named: "calendar_placeholder")
        yearLabel.text = getCurrentYear()
        createdByLabel.text = PFUser.currentUser()?.username
    }
    
    func getCurrentYear() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Y"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }
    
    func createDays(calendarId: String) {
        let year = getCurrentYear()
        
        for day in 1...25 {
            let newDay = PFObject(className: "Days")
            
            newDay["day"] = String(day)
            newDay["year"] = year
            newDay["calendarId"] = calendarId
            newDay.saveInBackground()
        }

    }

}
