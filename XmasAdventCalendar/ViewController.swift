//
//  ViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/2/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ViewController: UITabBarController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            
            // tell app which view controllers to connect to
            let logInViewController = LogInViewController()
            logInViewController.delegate = self
            logInViewController.signUpController = SignUpViewController()
            logInViewController.signUpController?.delegate = self

            
            // select elements to toggle
            logInViewController.fields = [.UsernameAndPassword, .LogInButton, .PasswordForgotten, .SignUpButton]
            
            // tell app to present view controller at start
            self.presentViewController(logInViewController, animated: false, completion: nil)
            
        } else {
            
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("calendars", sender: self)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("calendars", sender: self)
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
