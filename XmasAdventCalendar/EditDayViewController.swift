//
//  EditDayViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/7/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class EditDayViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // User selected object
    var selectedObject : PFObject?
    
    // Object to update
    var updateObject : PFObject?
    
    // Image Picker object
    var imagePicker = UIImagePickerController()
    var imageDidChange = false
    

    @IBOutlet weak var giftImage: PFImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteField: UITextView!

    
    //  MARK:   Actions
    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        // Use the sent country object or create a new country PFObject
        if let updateObjectTest = selectedObject as PFObject? {
            updateObject = selectedObject! as PFObject
        } else {
            updateObject = PFObject(className:"Days")
        }
        
        // Update the object
        if let updateObject = updateObject {
            
            updateObject["note"] = noteField.text

            
            // Upload any flag image
            if imageDidChange == true {
                let imageData = UIImagePNGRepresentation(giftImage.image!)
                let fileName = dateLabel.text! + ".png"
                let imageFile = PFFile(name:fileName, data:imageData!)
                updateObject["image"] = imageFile
            }
            
            
            // Save the data back to the server in a background task
            updateObject.save()
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // Present image picker
    // Will prompt user to allow permission to device photo library
    @IBAction func uploadGiftImage(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure delegate property for the form fields
        noteField.delegate = self
        
        // Unwrap the current object object
        if let object = selectedObject {
            
            // set day label
            var date = object["date"] as? NSDate
            var stringDate = formatDateLabel(date!)
            dateLabel.text = stringDate
            
            if let value = object["note"] as? String {
                noteField.text = value
            }
            
            // Display standard question image
            let initialThumbnail = UIImage(named: "present")
            giftImage.image = initialThumbnail
            
            // Replace question image if an image exists on the parse platform
            if let thumbnail = object["image"] as? PFFile {
                giftImage.file = thumbnail
                giftImage.loadInBackground()
            }
        }
    }
    
    
    //  MARK:   Custom Functions
    
    func formatDateLabel(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let stringDate = dateFormatter.stringFromDate(date)
        return stringDate
    }
    
    // Process selected image - add image to the parse object model
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            // Update the image within the app interface
            giftImage.image = pickedImage
            giftImage.contentMode = .ScaleAspectFit
            
            // Update the image did change flag so that we pick this up when the country is ssaved back to Parse
            imageDidChange = true
        }
        
        // Dismiss the image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
