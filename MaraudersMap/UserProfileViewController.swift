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
        groupTableViewHeightConstraint.constant = groupTableView.contentSize.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var itemsList = ["Group 1", "Group 2", "Group 3"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupViewCell") as UITableViewCell
        cell.textLabel.text = itemsList[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        groupName = itemsList[indexPath.row]
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
