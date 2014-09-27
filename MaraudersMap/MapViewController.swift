//
//  MapViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/27/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //make db calls
        println(userName)
        println(groupName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userName:String?
    var groupName:String?
}
