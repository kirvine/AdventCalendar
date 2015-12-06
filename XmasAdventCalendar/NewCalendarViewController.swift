//
//  NewCalendarViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/5/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NewCalendarViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // User selected object
    var currentObject : PFObject?
    
    // Object to update
    var updateObject : PFObject?
    
    // Image Picker object
    var imagePicker = UIImagePickerController()
    var imageDidChange = false

    @IBOutlet weak var calendarImage: PFImageView!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!

    
    // Present image picker
    // Will prompt user to allow permission to device photo library
    @IBAction func uploadImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
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

    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        // Use the sent country object or create a new country PFObject
        if let updateObjectTest = currentObject as PFObject? {
            updateObject = currentObject! as PFObject
        } else {
            updateObject = PFObject(className:"Calendars")
        }
        
        // Update the object
        if let updateObject = updateObject {
            
            updateObject["title"] = titleField.text
            updateObject["createdBy"] = PFUser.currentUser()?.username
            
            // Upload any flag image
            if imageDidChange == true {
                let imageData = UIImagePNGRepresentation(calendarImage.image!)
                let fileName = titleField.text! + ".png"
                let imageFile = PFFile(name:fileName, data: imageData!)
                updateObject["image"] = imageFile
            }
            
//            // Update the record ACL such that the new record is only visible to the current user
//            updateObject.ACL = PFACL(user: PFUser.currentUser()!)
            
            // Save the data back to the server in a background task
            updateObject.saveInBackground()
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set initial labels
        yearLabel.text = getCurrentYear()
        createdByLabel.text = PFUser.currentUser()?.username
        
        // Configure delegate property for the form fields
        titleField.delegate = self
        
        // Unwrap the current object
        if let object = currentObject {
            if let value = object["title"] as? String {
                titleField.text = value
            }
            if let value = object["createdBy"] as? String {
                createdByLabel.text = value
            }
            
            // Display standard image
            let initialThumbnail = UIImage(named: "merryxmas")
            calendarImage.image = initialThumbnail
            
            // Replace question image if an image exists on the parse platform
            if let thumbnail = object["image"] as? PFFile {
                calendarImage.file = thumbnail
                calendarImage.loadInBackground()
            }
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func getCurrentYear() -> String {
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "Y"
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        return convertedDate
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
