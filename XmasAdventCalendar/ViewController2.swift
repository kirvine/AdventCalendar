////
////  ViewController2.swift
////  XmasAdventCalendar
////
////  Created by Karen on 12/3/15.
////  Copyright © 2015 Karen. All rights reserved.
////
//
//import UIKit
//import Parse
//import ParseUI
//
//class ViewController2: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
//    
//    //    @IBOutlet weak var usernameField: UITextField!
//    //    @IBOutlet weak var passwordField: UITextField!
//    //    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView
//    
//    var backgroundImage : UIImageView!
//    
//    var logInViewController: PFLogInViewController! = PFLogInViewController()
//    var signUpViewController: PFSignUpViewController! = PFSignUpViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //        // style activity indicator
//        //        self.actInd.center = self.view.center
//        //        self.actInd.hidesWhenStopped = true
//        //        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        //
//        //        view.addSubview(self.actInd)
//        
//        self.presentViewController(self.logInViewController, animated: true, completion: nil)
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        if (PFUser.currentUser() == nil) {
//            
//            self.logInViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton, PFLogInFields.PasswordForgotten, PFLogInFields.DismissButton]
//            
//            var logInLogoTitle = UILabel()
//            logInLogoTitle.text = "Christmas Advent Calendar"
//            
//            self.logInViewController.logInView?.logo = logInLogoTitle
//            self.logInViewController.delegate = self
//            
//            var signUpLogoTitle = UILabel()
//            signUpLogoTitle.text = "Christmas Advent Calendar"
//            
//            self.signUpViewController.signUpView?.logo = signUpLogoTitle
//            self.signUpViewController.delegate = self
//            
//            self.logInViewController.signUpController = self.signUpViewController
//            
//        }
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    //  MARK:   Parse Login
//    
//    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
//        if (!username.isEmpty || !password.isEmpty) {
//            return true
//        } else {
//            return false
//        }
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
//        print("Failed to login.")
//    }
//    
//    
//    //  MARK:   Parse Sign UP
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
//        print("Failed to sign up.")
//    }
//    
//    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
//        print("User dismissed sign up.")
//    }
//    
//    //  MARK:   Actions
//    
//    
//    //    @IBAction func logInAction(sender: AnyObject) {
//    //        var username = self.usernameField.text
//    //        var password = self.passwordField.text
//    //
//    //        if (username?.utf16.count < 4 || password?.utf16.count < 6) {
//    //
//    //            var alert = UIAlertView(title: "Invalid", message: "Username must have 4 or more characters and password must be greater than 6 characters", delegate: self, cancelButtonTitle: "OK")
//    //
//    //        } else {
//    //
//    //            self.actInd.startAnimating()
//    //
//    //            PFUser.logInWithUsernameInBackground(username as String!, password: password as String!, block: { (user, error) -> Void in
//    //
//    //                self.actInd.stopAnimating()
//    //
//    //                if ((user) != nil) {
//    //
//    //                    var alert = UIAlertView(title: "Success", message: "Logged In", delegate: self, cancelButtonTitle: "OK")
//    //
//    //                } else {
//    //
//    //                    var alert = UIAlertView(title: "Error", message: "\(error)", delegate: self, cancelButtonTitle: "OK")
//    //                    alert.show()
//    //                }
//    //            })
//    //        }
//    //    }
//    //    
//    //    @IBAction func signUpAction(sender: AnyObject) {
//    //        self.performSegueWithIdentifier("signUp", sender: self)
//    //    }
//    
//}
