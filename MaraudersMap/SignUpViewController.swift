//
//  SignUpViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/26/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func verifyAndCreateAccount(sender: AnyObject) {
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("UserProfileViewController") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        
        self.presentViewController(viewController, animated: false, completion: nil)
        
    }
    @IBAction func cancelAccountCreation(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}