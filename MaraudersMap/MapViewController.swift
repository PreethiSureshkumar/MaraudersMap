//
//  MapViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/27/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var theMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //make db calls
        if(userName=="User 1" && groupName=="Group 1")
        {
            var latitude:CLLocationDegrees = 40.442764
            var longitude:CLLocationDegrees = -79.942544
            
            var latDelta:CLLocationDegrees = 0.01 //to zoom into the map when it launches
            var longDelta:CLLocationDegrees = 0.01
            
            var theSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta) //to make sure that zoom area is correct
            
            var churchLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            var theRegion:MKCoordinateRegion = MKCoordinateRegionMake(churchLocation, theSpan)
            
            self.theMapView.setRegion(theRegion, animated: true)
            
            var theUlmMinsterAnnotation = MKPointAnnotation()
            theUlmMinsterAnnotation.coordinate = churchLocation
            
            theUlmMinsterAnnotation.title = "CMU"
            theUlmMinsterAnnotation.subtitle = "Very famous"
            
            self.theMapView.addAnnotation(theUlmMinsterAnnotation)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var userName:String?
    var groupName:String?
}
