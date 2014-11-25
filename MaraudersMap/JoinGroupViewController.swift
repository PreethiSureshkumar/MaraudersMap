//
//  JoinGroupViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/27/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class JoinGroupViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var keyword: UITextField!
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var userName:String?
    var itemsList = [(String,String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
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
    
    /*func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }*/
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
    var joinAction = UITableViewRowAction(style: .Normal, title: "Join") { (action, indexPath) -> Void in
    tableView.editing = false
    println("join Group")
    }
    joinAction.backgroundColor = UIColor.blueColor()
    //joinAction.handler =
    
       
    return [joinAction]
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
                        if let groupidArr = jsonResult["groupid"] as? NSArray{
                            if let groupnameArr = jsonResult["groupnames"] as? NSArray {
                                for (index, value) in enumerate(groupidArr)
                                {
                                    var item : String = groupidArr[index] as String
                                    var name : String = groupnameArr[index] as String
                                    self.itemsList.append((item,name))
                                }
                                dispatch_async(dispatch_get_main_queue(), {
                                    self.groupTableView.reloadData()
                                })
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
