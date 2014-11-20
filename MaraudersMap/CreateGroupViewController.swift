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
    @IBOutlet weak var expirationSelect: UITextField!
    @IBOutlet weak var expirationPicker: UIPickerView!
    @IBOutlet weak var contactTableView: UITableView!
    
    @IBOutlet weak var Lat: UILabel!
    @IBOutlet weak var Long: UILabel!
    @IBOutlet weak var Addr: UILabel!
    
    var locationManager:CLLocationManager!
    var expirationOptions = ["1 hr", "2 hrs", "6 hrs", "12 hrs", "24 hrs", "2 days", "4 days", "1 week"]
    var selectedContacts = [String]()
    lazy var addressBook:ABAddressBookRef = {
        var error: Unmanaged<CFError>?
        return ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue() as ABAddressBookRef
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expirationPicker.dataSource = self
        expirationPicker.delegate = self
        expirationPicker.selectRow(4, inComponent: 0, animated: true)
        expirationSelect.text = expirationOptions[4]
        contactTableView.allowsMultipleSelection = true
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
        
        
        if let groupname = groupNameText.text {
            if let expirationDate = expirationSelect.text {
                var member:String = ""
                for (index, value) in enumerate(selectedContacts)
                {
                    var item : String = selectedContacts[index] as String
                    member+=item
                    member+=","
                }
                println(member.substringToIndex(member.endIndex.predecessor()))
                //construct the DB url
                /*let urlPath = "http://ec2-54-86-76-107.compute-1.amazonaws.com:8080/alpha/create-group?valid=\(expirationDate)&groupid=\(groupname)&member=\(member)"
                
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
                task.resume()*/

                
                //Go back to the user menu
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
        return expirationOptions[row]
    }
    
   
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        expirationSelect.text = expirationOptions[row]
    }
}