//
//  SignUpViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/3/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpViewController : PFSignUpViewController {
    
    var backgroundImage : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set custom background image
        customizeBackground()
    }
    
    //  MARK:   Customizations
    
    func customizeBackground() {
        backgroundImage = UIImageView(image: UIImage(named: "snow3"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.signUpView!.insertSubview(backgroundImage, atIndex: 0)
    }


}