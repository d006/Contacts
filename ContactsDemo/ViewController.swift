//
//  ViewController.swift
//  ContactsDemo
//
//  Created by doriswu on 2016/9/29.
//  Copyright © 2016年 doriswu. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var results: [CNContact] = []
    
    @IBOutlet weak var tableView: UITableView!
    var contactsArr = [CNContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let contactStore = CNContactStore()
        
        do {
            try contactStore.enumerateContactsWithFetchRequest(CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactMiddleNameKey, CNContactEmailAddressesKey,CNContactPhoneNumbersKey])) {
                (contact, cursor) -> Void in
                self.results.append(contact)
            }
        }
        catch{
            print("Handle the error please")
        }

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actShowContacts(sender: AnyObject) {
        
        let contactPickVc = CNContactPickerViewController()
        contactPickVc.delegate = self
        self.presentViewController(contactPickVc, animated: true, completion: nil)
    }
    
    // MARK: CNContactPickerDelegate func
    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
        
        contactsArr.append(contact)
        tableView.reloadData()
    }

    // MARK: UITableViewDataSource/UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if contactsArr.count > 0 || results.count > 0 {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var result = 0
        if contactsArr.count > 0 {
            result = contactsArr.count
        } else if results.count > 0 {
            result = results.count
        }
        
        return result
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        var data = CNContact()
        
        if contactsArr.count > 0 {
            data = contactsArr[indexPath.row]
        } else if results.count > 0 {
            data = results[indexPath.row]
        }
        
        cell.textLabel?.text = data.familyName + data.givenName
        if data.phoneNumbers.count > 0 {
            cell.detailTextLabel?.text = (data.phoneNumbers[0].value as! CNPhoneNumber).valueForKey("digits") as? String
        } else {
            cell.detailTextLabel?.text = "無號碼"
        }
        return cell
    }
}

