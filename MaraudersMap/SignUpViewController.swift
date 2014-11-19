//
//  SignUpViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/26/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var newUserName: UITextField!
    @IBOutlet weak var newUserContactNo: UITextField!
    @IBOutlet weak var newUserPassword1: UITextField!
    @IBOutlet weak var newUserPassword2: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func verifyAndCreateAccount(sender: AnyObject) {
        
        /*let viewController:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("UserProfileViewController") as UIViewController
        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
        
        self.presentViewController(viewController, animated: false, completion: nil)*/
        
        if newUserPassword1.text == newUserPassword2.text {
            if let userName = newUserName.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
                if newUserContactNo != nil {
                    if let newPassword = newUserPassword1.text.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
                    let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/register?account=\(newUserContactNo.text)&name=\(userName)&password=\(newPassword)"
                    println(urlPath)
                    
                    let url: NSURL! = NSURL(string: urlPath)
                    
                    let session = NSURLSession.sharedSession()
                    
                    let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                        println("Task completed")
                        if(error != nil) {
                            // If there is an error in the web request, print it to the console
                            println(error.localizedDescription)
                        } else {
                            println(data)
                        }
                        var err: NSError?
                        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                        if(err != nil) {
                            // If there is an error parsing JSON, print it to the console
                            
                        }
                        let results: String = jsonResult["status"] as String
                        println(results)
                        if results == "OK" {
                            dispatch_async(dispatch_get_main_queue(), {
                                self.performSegueWithIdentifier("profilePushSegue", sender: self)
                            })
                        }
                    })
                    task.resume()
                    
                    }

                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "profilePushSegue"){
            var profilePageController = segue.destinationViewController as TabBarControllerMM
            profilePageController.userNameTab = newUserContactNo.text
        }
    }
    

    @IBAction func cancelAccountCreation(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}