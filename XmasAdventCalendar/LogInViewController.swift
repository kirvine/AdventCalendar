//
//  LogInViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/3/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LogInViewController : PFLogInViewController {
    
    var backgroundImage : UIImageView!
    var viewsToAnimate: [UIView!]!
    var viewsFinalYPosition : [CGFloat]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set custom background image
        customizeBackground()
        
        // custom logo
        customizeLogo()
        
        // customize login button
        customizeLogIn()
        
        // customize forgot password
        customizeForgotPassword()

        // customize sign up button
        customizeSignUp(logInView?.signUpButton!)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRectMake( 0,  0,  self.logInView!.frame.width,  self.logInView!.frame.height)
        
        // position logo at top
        positionLogo()

    }
    
    
    //  MARK:   Customizations
    
    func customizeBackground() {
        backgroundImage = UIImageView(image: UIImage(named: "bg_snow"))
        backgroundImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.logInView!.insertSubview(backgroundImage, atIndex: 0)
    }
    
    func customizeLogo() {
        let logo = UILabel()
        logo.text = "Advent Calendar"
        logo.textColor = UIColor.whiteColor()
        logo.font = UIFont(name: "Pacifico", size: 42)
        logo.shadowColor = UIColor.lightGrayColor()
        logo.shadowOffset = CGSizeMake(2, 2)
        logInView?.logo = logo
    }
    
    func customizeLogIn() {
        logInView?.logInButton?.setTitleColor(UIColor.redColor(), forState: .Normal)
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor.whiteColor()
    }
    
    func customizeForgotPassword() {
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    func customizeSignUp(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func positionLogo() {
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRectMake(logoFrame.origin.x, logInView!.usernameField!.frame.origin.y - logoFrame.height - 16, logInView!.frame.width,  logoFrame.height)
    }
    
}