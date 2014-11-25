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

class CreateGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    //@IBOutlet weak var expirationDateLabel: UILabel!
    
    //@IBOutlet weak var expirationDatePicker: UIDatePicker!
    //@IBOutlet weak var expirationLabel: UILabel!
    
    @IBOutlet weak var groupNameText: UITextField!
    @IBOutlet weak var expirationPicker: UIPickerView!
    @IBOutlet weak var contactTableView: UITableView!
    
    @IBOutlet weak var Lat: UILabel!
    @IBOutlet weak var Long: UILabel!
    @IBOutlet weak var Addr: UILabel!
    
    var locationManager:CLLocationManager!
    var expirationOptions = [("1 hr",1), ("2 hrs",2), ("6 hrs",6), ("12 hrs",12), ("24 hrs",24), ("2 days",48), ("4 days",96), ("1 week",168)]
    var selectedContacts = [String]()
    var validity = 24
    var userName:String?
    lazy var addressBook:ABAddressBookRef = {
        var error: Unmanaged<CFError>?
        return ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue() as ABAddressBookRef
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expirationPicker.dataSource = self
        expirationPicker.delegate = self
        expirationPicker.selectRow(4, inComponent: 0, animated: true)
        contactTableView.allowsMultipleSelection = true
        var tabBar:TabBarControllerMM = self.tabBarController as TabBarControllerMM
        self.userName = tabBar.userNameTab
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
        
        //Gather Data to create a group
        
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
            
            let phoneNumberProperty:ABMultiValueRef = ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
            
            var phoneNumberArray:NSArray = ABMultiValueCopyArrayOfAllValues(phoneNumberProperty).takeRetainedValue() as NSArray
            
            
            //var contactNo: String = ABMultiValueCopyValueAtIndex(phoneNumbers, ABMultiValueGetIndexForIdentifier(phoneNumbers, ABMultiValueGetIdentifierAtIndex(phoneNumbers, 0))).takeRetainedValue() as NSString
            
            var contactNo: String = phoneNumberArray[0] as NSString
            
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
        cell.textLabel.text = namesAndNumbers[indexPath.row].0
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let number = namesAndNumbers[indexPath.row].1
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        selectedContacts+=[number]
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell!
        cell.accessoryType = UITableViewCellAccessoryType.None
    }
    
    
    @IBAction func createGroup(sender: AnyObject) {
        //Get all the selected values and push it to DB
    println(self.userName)
        
        if let groupname = groupNameText.text {
            if let username = self.userName {
                var member:String = ""
                for (index, value) in enumerate(selectedContacts)
                {
                    var item : String = selectedContacts[index] as String
                    item  = item .stringByReplacingOccurrencesOfString("(", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    item  = item .stringByReplacingOccurrencesOfString(")", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    item  = item .stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    item  = item .stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                    member+=item
                    member+=","
                }
               
                //construct the DB url
                println(validity)
                let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/create-group?name=\(groupname)&user=\(username)&members=\(member.substringToIndex(member.endIndex.predecessor()))&valid=\(validity)"
                
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
                        dispatch_async(dispatch_get_main_queue(), {
                        var alert = UIAlertController(title: "Success", message: "Group Created", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                })
                task.resume()

            }
        }
        
        //Getting GPS data
        /*locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()*/
        
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return expirationOptions.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return expirationOptions[row].0
    }
    
   
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.validity = expirationOptions[row].1
    }
}