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

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()

        // style activity indicator
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        view.addSubview(self.actInd)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:    Actions
    
    @IBAction func signUpAction(sender: AnyObject) {
        var email = self.emailField.text
        var username = self.usernameField.text
        var password = self.passwordField.text
        
        if (username?.utf16.count < 4 || password?.utf16.count < 6) {
            
            var alert = UIAlertView(title: "Invalid", message: "Username must have 4 or more characters and password must be greater than 6 characters", delegate: self, cancelButtonTitle: "OK")
            
        } else {
            
            self.actInd.startAnimating()
            
            PFUser.logInWithUsernameInBackground(username as String!, password: password as String!, block: { (user, error) -> Void in
                
                self.actInd.stopAnimating()
                
                if ((user) != nil) {
                    
                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
                    
                } else if (email?.utf16.count < 8) {
                    
                    var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email.", delegate: self, cancelButtonTitle: "OK")
                    
                } else {
                    
                    self.actInd.startAnimating()
                    
                    var newUser = PFUser()
                    
                    newUser.email = email
                    newUser.username = username
                    newUser.password = password
                    
                    newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                        
                        self.actInd.stopAnimating()
                        
                        if ((error) != nil) {
                            var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
                            alert.show()

                        } else {
                            var alert = UIAlertView(title: "Success", message: "Signed Up!", delegate: self, cancelButtonTitle: "OK")
                            alert.show()
                        }
                        
                    })
                    
                }
                
            })
            
        }
        
    }
    
}
