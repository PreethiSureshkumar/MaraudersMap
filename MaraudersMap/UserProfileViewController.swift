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
    var itemsList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileImage.layer.cornerRadius = 40.0
        ProfileImage.clipsToBounds = true
        groupTableView.dataSource = self
        groupTableView.delegate = self
        var home_selected:UIImage! = UIImage(named: "home_selected.png")
        HomePageItem.selectedImage = home_selected
        var tabBar:TabBarControllerMM = self.tabBarController as TabBarControllerMM
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
                        if let groupArr = jsonResult["groupid"] as? NSArray{
                            for (index, value) in enumerate(groupArr)
                            {
                                var item : String = groupArr[index] as String
                                self.itemsList+=[item]
                            }
                            dispatch_async(dispatch_get_main_queue(), {
                                self.groupTableView.reloadData()
                            })
                        }
                    }
                })
                task.resume()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        var badgeValue:String = HomePageItem.badgeValue!
        var badgeNo:Int = badgeValue.toInt()!
        badgeNo = badgeNo + 1
        HomePageItem.badgeValue = "\(badgeNo)"
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
        cell.textLabel.text = self.itemsList[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        groupName = self.itemsList[indexPath.row]
        self.performSegueWithIdentifier("LoadMapSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "LoadMapSegue"){
            var mapViewController = segue.destinationViewController as MapViewController
            mapViewController.userName = self.userName
            mapViewController.groupName = groupName
        }
    }
}
