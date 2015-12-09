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
        
        // custom logo
        customizeLogo()
        
        // customize sign up button
        customizeSignUp(signUpView?.signUpButton!)
        
        // customize dismiss button to say: Already signed up?
        customizeDismissButton()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  self.signUpView!.frame.width,  self.signUpView!.frame.height)
        
        // position logo at top
        positionLogo()
        
        // re-position dismiss button to be below sign
        positionDismissButton()
        
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal

    }
    
    //  MARK:   Customizations
    
    func customizeBackground() {
        backgroundImage = UIImageView(image: UIImage(named: "bg_snow"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.signUpView!.insertSubview(backgroundImage, atIndex: 0)
    }
    
    func customizeLogo() {
        let logo = UILabel()
        logo.text = "Advent Calendar"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Pacifico", size: 42)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        signUpView?.logo = logo
    }
    
    func customizeSignUp(button: UIButton!) {
        signUpView?.signUpButton?.setTitleColor(UIColor.grayColor(), forState: .Normal)
        signUpView?.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        signUpView?.signUpButton?.backgroundColor = UIColor.whiteColor()
    }
    
    func customizeDismissButton() {
        signUpView?.dismissButton!.setTitle("Already signed up?", forState: .Normal)
        signUpView?.dismissButton!.setImage(nil, forState: .Normal)
    }
    
    func positionLogo() {
        signUpView!.logo!.sizeToFit()
        let logoFrame = signUpView!.logo!.frame
        signUpView!.logo!.frame = CGRectMake(logoFrame.origin.x, signUpView!.usernameField!.frame.origin.y - logoFrame.height - 16, signUpView!.frame.width,  logoFrame.height)
    }
    
    func positionDismissButton() {
        let dismissButtonFrame = signUpView!.dismissButton!.frame
        signUpView?.dismissButton!.frame = CGRectMake(0, signUpView!.signUpButton!.frame.origin.y + signUpView!.signUpButton!.frame.height + 16.0,  signUpView!.frame.width,  dismissButtonFrame.height)
    }

}