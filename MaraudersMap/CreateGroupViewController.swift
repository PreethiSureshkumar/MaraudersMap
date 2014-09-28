//
//  CreateGroupViewController.swift
//  MaraudersMap
//
//  Created by Preethi Sureshkumar on 9/27/14.
//  Copyright (c) 2014 CMU. All rights reserved.
//

import UIKit
import AddressBook
import CoreLocation

class CreateGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var expirationDateLabel: UILabel!
    
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    
    @IBOutlet weak var contactTableView: UITableView!
    
    @IBOutlet weak var Lat: UILabel!
    @IBOutlet weak var Long: UILabel!
    @IBOutlet weak var Addr: UILabel!
    var locationManager:CLLocationManager!
    
    lazy var addressBook:ABAddressBookRef = {
        var error: Unmanaged<CFError>?
        return ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue() as ABAddressBookRef
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch ABAddressBookGetAuthorizationStatus(){
        case .Authorized:
            readFromAddressBook(addressBook)
        case .Denied:
            println("No access")
        case .NotDetermined:
            ABAddressBookRequestAccessWithCompletion(addressBook, {[weak self] (granted:Bool, error: CFError!) in
                if granted{
                    let strongSelf = self!
                    println("Access is granted")
                    strongSelf.readFromAddressBook(strongSelf.addressBook)
                } else {
                    println("No access")
                }
            })
        case .Restricted:
            println("Restricted")
        default:
            println("unhandled")
        }
        
        
    }
    
    var namesAndNumbers = [(String, String)]()
    
    func readFromAddressBook(addressBook:ABAddressBookRef){
        //let addressBook : ABAddressBookRef = ABAddressBookCreateWithOptions(nil,
        //    nil).takeRetainedValue()
        
        var source : ABRecordRef =
        ABAddressBookCopyDefaultSource(addressBook).takeRetainedValue()
        
        let sortOrder : ABPersonSortOrdering =
        UInt32(kABPersonSortByLastName)
        
        let allPeople =
        ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook,
            source, sortOrder).takeRetainedValue() as NSArray
        
        //let allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
        
        namesAndNumbers = [(String, String)]()
        for person: ABRecordRef in allPeople{
            println(person)
            var contactName: String = ABRecordCopyCompositeName(person).takeRetainedValue() as NSString
            println ("contactName \(contactName)")
            
            let phoneNumbers: ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue() as ABMultiValueRef
            
            var contactNo: String = ABMultiValueCopyValueAtIndex(phoneNumbers, ABMultiValueGetIndexForIdentifier(phoneNumbers, ABMultiValueGetIdentifierAtIndex(phoneNumbers, 0))).takeRetainedValue() as NSString
            
            println(contactNo)
            
            namesAndNumbers.append((contactName, contactNo))
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesAndNumbers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupViewCell") as UITableViewCell
        cell.textLabel!.text = namesAndNumbers[indexPath.row].0
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let number = namesAndNumbers[indexPath.row].1
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    
    @IBAction func createGroup(sender: AnyObject) {
        //Get all the selected values and push it to DB
        
        //Getting GPS data
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
        var alert = UIAlertController(title: "Error", message: "MESSAGE", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        //if (locationFixAchieved == false) {
          //  locationFixAchieved = true
            println("Inside update location")
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
        //}
    }
}