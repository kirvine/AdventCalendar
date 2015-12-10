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
    
    // user selected object
    var selectedObject: PFObject?
    // object to update
    var updateObject: PFObject?
    
    var isNewObject: Bool = true
    
    // Image Picker object
    var imagePicker = UIImagePickerController()
    var imageDidChange = false

    @IBOutlet weak var calendarImage: PFImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var viewersField: UITextView!

    
    //  MARK:   Actions
    
    // Prompt user to allow permission to device photo library
    @IBAction func uploadImage(sender: AnyObject) {
       
        let optionMenu = createImageUploadMenu()
        self.presentViewController(optionMenu, animated: true, completion: nil)
    
    }
    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        // use selected object
        if isNewObject {
            // create new object
            updateObject = PFObject(className:"Calendars")
        } else {
            // use current selected object
            updateObject = selectedObject! as PFObject
        }
        
        // Update the object
        if let calendarObject = updateObject {
            if titleField.text == "" {
                
                let alertMsg = UIAlertController(title: "Error", message: "Calendar must have a title", preferredStyle: UIAlertControllerStyle.Alert)
                alertMsg.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                self.presentViewController(alertMsg, animated: true, completion: nil)
                
            } else {
                
                calendarObject["title"] = titleField.text
                calendarObject["year"] = getCurrentYear()
                calendarObject["createdBy"] = PFUser.currentUser()?.username
                calendarObject["viewedBy"] = formatViewersField()
                
                // Upload image
                if imageDidChange == true {
                    let imageData = UIImagePNGRepresentation(calendarImage.image!)
                    let imageFile = PFFile(data: imageData!)
                    calendarObject["image"] = imageFile
                    
                }
                // Save the data back to the server in a background task
                calendarObject.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // Now create days if necessary
                        if let id = calendarObject.objectId {
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
        
        print("*new cal vdl")

        
        imagePicker.delegate = self
        titleField.delegate = self
        
        // set initial labels and fields
        testIsNew()
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

    func testIsNew() {
        if let selected = selectedObject as PFObject? {
            isNewObject = false
        }
    }
    
    func updateLabels() {
        if isNewObject {
            // object is new
            calendarImage.image = UIImage(named: "calendar_placeholder")
            let year = getCurrentYear()
            yearLabel.text = "\(year) Holiday Season"
            let creator = PFUser.currentUser()?.username
            createdByLabel.text = "Created by \(creator!)"
        } else {
            // load attributes of selected object
            let updateObject = selectedObject! as PFObject
            
            if let imageFile = updateObject.objectForKey("image") as? PFFile {
                calendarImage.file = imageFile
                calendarImage.loadInBackground()
            } else {
                let placeholder = UIImage(named: "calendar_placeholder")
                calendarImage.image = placeholder
            }
            titleField.text = updateObject.objectForKey("title") as? String
            let year = updateObject.objectForKey("year") as? String
            yearLabel.text = "\(year) Holiday Season"
            let creator = updateObject.objectForKey("createdBy") as? String
            createdByLabel.text = "Created by \(creator)"
            let viewers = updateObject.objectForKey("viewedBy") as? [String]
            viewersField.text = viewers!.joinWithSeparator(" ")
        }
    }
    
    func getCurrentYear() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Y"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
    }
    
    func formatViewersField() -> [String] {
        var input = viewersField.text!
        let separators = NSCharacterSet(charactersInString: ":,; \n")
        var nameArray = input.componentsSeparatedByCharactersInSet(separators)
        
        // remove empty whitespace characters
        nameArray = nameArray.filter { (x) -> Bool in
            !x.isEmpty
        }
        
        // make sure all usernames lowercase
        let finalArray = nameArray.map({ $0.lowercaseString })
        
        return finalArray
    }
    
    func createDays(calendarId: String) {
        if isNewObject {
            let year = Int(getCurrentYear())
            
            for day in 1...25 {
                let newDay = PFObject(className: "Days")
                
                newDay["day"] = day
                newDay["year"] = year
                newDay["calendarId"] = calendarId
                newDay.saveInBackground()
            }
        }
    }

    
    
    
    
    
}
