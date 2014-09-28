//
//  ViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/26/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoginImage.layer.cornerRadius = 40.0
        LoginImage.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var LoginImage: UIImageView!
    
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBAction func verifyUsernamePassword(sender: AnyObject)  {
        
        /*let account = userName.text
        
        let password = passWord.text
        
        
        
        // Now escape anything else that isn't URL-friendly
        
        if let account = userName.text {
            
            if let password = passWord.text {
                
                let urlPath = "http://localhost:8080/MMap/login?account=\(account)&password=\(password)"
                
                println(urlPath)
                
                let url: NSURL = NSURL(string: urlPath)
                
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
                        
                        println("JSON Error \(err!.localizedDescription)")
                        
                    }
                    
                    let results: Int = jsonResult["status"] as Int
                    
                    println(results)
                    
                    if results == 0 {*/
                        
                        let viewController:UIViewController = UIStoryboard(name: "Main", bundle:nil).instantiateViewControllerWithIdentifier("UserProfileViewController") as UIViewController
                        
                        // .instantiatViewControllerWithIdentifier() returns AnyObject! this must be downcast to utilize it
                        
                        
                        
                        self.presentViewController(viewController, animated: false, completion: nil)
                        
                    /*}
                    
                })
                
                
                
                task.resume()
                
            }
            
        }*/
        
    }
}

