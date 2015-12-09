//
//  AdventCalendarViewController.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/9/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit

class AdventCalendarViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "advent"))
        
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = imageView.bounds.size
        scrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        scrollView.addSubview(imageView)
        view.addSubview(scrollView)
        
        
        let buttonOne = UIButton.init(type: .System)
        buttonOne.frame = CGRectMake(10, 50, 50, 50)
        buttonOne.backgroundColor = UIColor.greenColor()
        buttonOne.setTitle("test", forState: UIControlState.Normal)
        buttonOne.addTarget(self, action: "buttonAction1x1:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.scrollView = UIScrollView()
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(1000, 1000)
        
        containerView = UIView()
        
        
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
        containerView.addSubview(buttonOne)
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

}
