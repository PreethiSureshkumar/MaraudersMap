//
//  TabBarControllerMM.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/28/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//


import UIKit

class TabBarControllerMM: UITabBarController {
    var userNameTab:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println(userNameTab)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
