//
//  UserProfileViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/26/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    @IBOutlet weak var groupTableViewHeightConstraint: NSLayoutConstraint!
    
    var groupName:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileImage.layer.cornerRadius = 40.0
        ProfileImage.clipsToBounds = true
        groupTableView.dataSource = self
        groupTableView.delegate = self
        
        //groupTableViewHeightConstraint.constant = groupTableView.contentSize.height
//        groupTableView.sizeToFit()
       // println("Breakpoint")
    }
    
    override func viewWillLayoutSubviews() {
        groupTableView.sectionFooterHeight = 0
        //groupTableView.frame.size.height = groupTableView.contentSize.height
        groupTableViewHeightConstraint.constant = groupTableView.contentSize.height
                //groupTableView.sizeToFit()
        //println("Breakpoint")
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
        cell.textLabel!.text = itemsList[indexPath.row]
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
            mapViewController.userName = "User 1"
            mapViewController.groupName = groupName
        }
    }
    
}
