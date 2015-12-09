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
    
    // Image Picker object
    var imagePicker = UIImagePickerController()
    var imageDidChange = false
    

    @IBOutlet weak var giftImage: PFImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteField: UITextView!

    
    //  MARK:   Actions
    
    // Present image picker
    @IBAction func uploadImage(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Upload Image", preferredStyle: .ActionSheet)
        
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
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    // The save button
    @IBAction func saveButton(sender: AnyObject) {
        
        // Update the object
        if let day = selectedObject {
            
            day["note"] = noteField.text
            
            // Upload any gift image
            if imageDidChange == true {
                
                let imageData = UIImagePNGRepresentation(giftImage.image!)
                let imageFile = PFFile(data:imageData!)
                day["image"] = imageFile
                
            }
            
            // Save the data back to the server in a background task
            day.saveInBackground()
        }
        
        // Return to table view
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        // Configure delegate property for the form fields
        noteField.delegate = self
        
        // Unwrap the selected object
        if let object = self.selectedObject {
            
            // set day label
            let number = object.objectForKey("day") as? String
            dateLabel.text  = "Dec \(number!)"
            
            // set contents of note field
            if let value = object.objectForKey("note") as? String {
                noteField.text = value
            }
            
            if let imageFile = object.objectForKey("image") as? PFFile {
                // image has been uploaded
                giftImage.file = imageFile
                giftImage.loadInBackground()
            } else {
                // no image present
                let placeholder = UIImage(named: "day_placeholder")
                giftImage.image = placeholder
            }
        }
    }
    
    //  MARK:   UIImagePicker Functions
    
    // Process selected image & add back to parse object
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            // Update the image within the app interface
            giftImage.image = pickedImage
            giftImage.contentMode = .ScaleAspectFit
            
            // Update the image did change flag so that we pick this up when the country is ssaved back to Parse
            imageDidChange = true
        }
        
        // Dismiss the image picker
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}



