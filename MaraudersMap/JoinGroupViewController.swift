//
//  JoinGroupViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/27/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class JoinGroupViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var keyword: UITextField!
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var userName:String?
    var itemsList = [(String,String,Int)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        keyword.delegate = self
        var tabBar:TabBarControllerMM = self.tabBarController as TabBarControllerMM
        self.userName = tabBar.userNameTab
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupViewCell") as UITableViewCell
        cell.textLabel.text = self.itemsList[indexPath.row].1
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
             return true
    }
    
    /*func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }*/
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
    var joinAction = UITableViewRowAction(style: .Normal, title: "Join") { (action, indexPath) -> Void in
    //tableView.editing = false
    //DB call here
        var group:String? = self.itemsList[indexPath.row].0 as String
        if let groupid =  group{
            if let username = self.userName {
                let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/request?account=\(username)&groupid=\(groupid)"
                
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
                        println(err)
                    }
                    let results: String = jsonResult["status"] as String
                    println(results)
                    if results == "OK" {
                        self.itemsList[indexPath.row].2 = 2
                        dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title: "Success", message: "Join Request Sent", preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                })
                task.resume()
                
            }
        }
        self.groupTableView.reloadData()
    }
    joinAction.backgroundColor = UIColor.blueColor()
    
        
    var joinedAction = UITableViewRowAction(style: .Normal, title: "Show Map") { (action, indexPath) -> Void in
            //Goto Segue to show the map
    }
    joinedAction.backgroundColor = UIColor.yellowColor()
    
    var acceptAction = UITableViewRowAction(style: .Normal, title: "Accept") { (action, indexPath) -> Void in
            var group:String? = self.itemsList[indexPath.row].0 as String
            if let groupid =  group{
                if let username = self.userName {
                    let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/request?account=\(username)&groupid=\(groupid)"
                    
                    println(urlPath)
                    let url: NSURL! = NSURL(string: urlPath)
                    
                    let session = NSURLSession.sharedSession()
                    
                    let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                        println("Task completed")
                        if(error != nil) {
                            // If there is an error in the web request, print it to the console
                            println(error.localizedDescription)
                        } /*else {
                            println(data)
                        }*/
                        var err: NSError?
                        var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                        if(err != nil) {
                            // If there is an error parsing JSON, print it to the console
                            println(err)
                        }
                        let results: String = jsonResult["status"] as String
                        println(results)
                        if results == "INVITED" {
                            self.itemsList[indexPath.row].2 = 100
                            dispatch_async(dispatch_get_main_queue(), {
                                var alert = UIAlertController(title: "Success", message: "Join Request Accepted", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                            })
                        }
                    })
                    task.resume()
                    
                }
            }
            self.groupTableView.reloadData()
        }
        acceptAction.backgroundColor = UIColor.greenColor()
        
        var pendingAction = UITableViewRowAction(style: .Normal, title: "Pending") { (action, indexPath) -> Void in
            //Goto Segue to show the map
        }
        pendingAction.backgroundColor = UIColor.grayColor()
        
        if self.itemsList[indexPath.row].2==0 {
             return [joinAction]
        }
        
        if self.itemsList[indexPath.row].2==1 {
            return [acceptAction]
        }
        
        if self.itemsList[indexPath.row].2==2 {
            return [pendingAction]
        }
        
        return [joinedAction]
        
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
    
    
    @IBAction func searchKeyword(sender: AnyObject) {
        if keyword.text != nil {
            if let searchword = keyword.text {
                if let username = self.userName {
                let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/search-group?keyword=\(searchword)&user=\(username)"
                
                println(urlPath)
                
                let url: NSURL! = NSURL(string: urlPath)
                
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
                    println("Task completed")
                    if(error != nil) {
                        // If there is an error in the web request, print it to the console
                        println(error.localizedDescription)
                    } /*else {
                        println(data)
                    }*/
                    var err: NSError?
                    var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println(err)
                    }
                    let results: String = jsonResult["status"] as String
                    println(results)
                    
                    if results == "OK" {
                    if let groupidArr = jsonResult["groupid"] as? NSArray{
                        if let groupnameArr = jsonResult["groupnames"] as? NSArray {
                            if let relationArr = jsonResult["relation"] as? NSArray {
                                self.itemsList = [(String,String,Int)]()
                                for (index, value) in enumerate(groupidArr)
                                {
                                    var item : String = groupidArr[index] as String
                                    var name : String = groupnameArr[index] as String
                                    var relation : Int = relationArr[index] as Int
                                    self.itemsList.append((item,name,relation))
                                }
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.groupTableView.reloadData()
                                })
                            }
                        }
                    }
                    }
                })
                task.resume()
                }
            }
        }
    }
        
}

func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
{
    textField.resignFirstResponder()
    return true;
}
