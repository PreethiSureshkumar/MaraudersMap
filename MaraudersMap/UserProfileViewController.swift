//
//  UserProfileViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/26/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var HomePageItem: UITabBarItem!
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBOutlet weak var UserNameUserProfile: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var groupTableViewHeightConstraint: NSLayoutConstraint!
    
    var groupName:String?
    var userName:String?
    var itemsList = [(String,String,Int)]()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileImage.layer.cornerRadius = 40.0
        ProfileImage.clipsToBounds = true
        groupTableView.dataSource = self
        groupTableView.delegate = self
        var home_selected:UIImage! = UIImage(named: "home_selected.png")
        HomePageItem.selectedImage = home_selected
        var tabBar:TabBarControllerMM = tabBarController as TabBarControllerMM
        self.userName = tabBar.userNameTab
        UserNameUserProfile.text = self.userName
        
        if let accountID = self.userName {
                
                let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/list-group?account=\(accountID)"
                
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
                            if let groupnameArr = jsonResult["groupname"] as? NSArray {
                                if let relationArr = jsonResult["relations"] as? NSArray {
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
    
    override func viewDidAppear(animated: Bool) {
        /*var badgeValue:String = HomePageItem.badgeValue!
        var badgeNo:Int = badgeValue.toInt()!
        badgeNo = badgeNo + 1
        HomePageItem.badgeValue = "\(badgeNo)"*/
        if let accountID = self.userName {
            
            let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/list-group?account=\(accountID)"
            
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
                /*var groupIdList = [String]()
                for (index, value) in enumerate(self.itemsList)
                {
                    var item: String = self.itemsList[index].0
                    groupIdList.append(item)
                }*/
                if results == "OK" {
                    if let groupidArr = jsonResult["groupid"] as? NSArray{
                        if let groupnameArr = jsonResult["groupname"] as? NSArray {
                            if let relationArr = jsonResult["relations"] as? NSArray {
                                self.itemsList = [(String,String,Int)]()
                            for (index, value) in enumerate(groupidArr)
                            {
                                var item : String = groupidArr[index] as String
                                var name : String = groupnameArr[index] as String
                                var relation : Int = relationArr[index] as Int
                                
                                /*if contains(groupIdList,item){
                                    
                                }else { */
                                self.itemsList.append((item,name,relation))
                                //}
                                
                            }
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
    override func viewWillLayoutSubviews() {
        groupTableView.sectionHeaderHeight = 0.0
        groupTableView.sectionFooterHeight = 0.0
        groupTableView.reloadData()
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        groupName = self.itemsList[indexPath.row].1
        self.performSegueWithIdentifier("LoadMapSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
           
        }
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
        var deleteAction = UITableViewRowAction(style: .Normal, title: "Delete") { (action, indexPath) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                var alert = UIAlertController(title: "Delete Group", message:
                    "This will block all notifications from this group.Are you sure?", preferredStyle: UIAlertControllerStyle.Alert)
                
                self.presentViewController(alert, animated: false, completion: nil)
                
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default,
                    handler: nil))
                alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler:
                    {action in      
                        self.removeGroup(indexPath.row)
                }))
            })

            
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
        var leaveAction = UITableViewRowAction(style: .Normal, title: "Leave") { (action, indexPath) -> Void in
            self.removeGroup(indexPath.row)
        }
        leaveAction.backgroundColor = UIColor.redColor()
        
        if self.itemsList[indexPath.row].2==101 {
            return [deleteAction]
        }
        
        else {
            return [leaveAction]
        }

        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "LoadMapSegue"){
            var mapViewController = segue.destinationViewController as MapViewController
            mapViewController.userName = self.userName
            mapViewController.groupName = groupName
        }
    }
    
    func removeGroup(rowNo:Int) {
        let val = self.itemsList[rowNo]
        //perform DB call and update the DB
        var gId:String? = val.0 as String
        if let groupid = gId {
            if let username = self.userName {
                let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/delete?account=\(username)&groupid=\(groupid)"
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
                    var groupIdList = [String]()
                    for (index, value) in enumerate(self.itemsList)
                    {
                        var item: String = self.itemsList[index].0
                        groupIdList.append(item)
                    }
                    if results == "OK" {
                        // Tell the table view to animate out that row
                        dispatch_async(dispatch_get_main_queue(), {
                            self.itemsList.removeAtIndex(rowNo)
                            self.groupTableView.reloadData()
                        })
                        
                    }
                    
                    if results == "NO_GRANT" {
                        dispatch_async(dispatch_get_main_queue(), {
                            var alert = UIAlertController(title: "No Access", message: "Only admin can delete the group", preferredStyle: UIAlertControllerStyle.Alert)
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
    
}
