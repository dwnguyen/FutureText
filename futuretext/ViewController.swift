//
//  ViewController.swift
//  futuretext
//
//  Created by David Nguyen on 1/16/16.
//  Copyright (c) 2016 David Nguyen. All rights reserved.
//

import UIKit
import MessageUI
import mailgun
import ContactsUI


@available(iOS 9.0, *)
class ViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, CNContactPickerDelegate {
    
    /** Takes user input for the user's name*/
    @IBOutlet weak var nameField: UITextField!
    /** Takes user input for the message to be sent*/
    @IBOutlet weak var messageField: UITextView!
    /** Takes user input for number to which the message is sent*/
    @IBOutlet weak var phoneField: UITextField!
    /** Takes user input for the date at which the message is sent*/
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /** Stores the name of the user*/
    var name :String{
        get {
            if let returnValue = NSUserDefaults.standardUserDefaults().objectForKey("name") as? String {
                return returnValue
            } else {
                return "Enter your name" //Default value
            }
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "name")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameField.text = name
        messageField.editable = true
        nameField.delegate = self
        phoneField.delegate = self
        messageField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    /**
     Sends a text by emailing service provider when linked button is pressed.
     Uses the provided name and phone number from the text fields.
     
     - Parameter sender:   The button that calls the method (Send to Future)
    */
    @IBAction func sendText(sender: UIButton) {
        let mailgun: Mailgun = Mailgun.clientWithDomain("sandboxb5df4d368c4c472ea05844e6da828448.mailgun.org", apiKey: "key-eb644fc9dafb391e4135512567198c7d")
        let seconds = datePicker.date.timeIntervalSinceNow - 60
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        print(seconds)
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            mailgun.sendMessageTo("Reciever <" + self.phoneField.text! + "@txt.att.net>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
            mailgun.sendMessageTo("Reciever <" + self.phoneField.text! + "@vtext.com>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
            mailgun.sendMessageTo("Reciever <" + self.phoneField.text! + "@tmomail.net>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
            mailgun.sendMessageTo("Reciever <" + self.phoneField.text! + "@messaging.sprintpcs.com>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
            print("Message Sent")
            
        })
        
    }
    
    
    @IBAction func viewContacts(sender: AnyObject) {
        let contactStore = AppDelegate.getAppDelegate().contactStore
        if !AppDelegate.getAppDelegate().checkContactAccess(){
            AppDelegate.getAppDelegate().requestContactAccess()
        }
        else{
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.displayedPropertyKeys =
                [CNContactPhoneNumbersKey]
            self.presentViewController(contactPicker, animated: true, completion: nil)
        }
    }
    
    
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        phoneField.text = contactProperty.value!.valueForKey("digits")! as! String
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    /** Clears the text view when the user begins editing*/
    func textViewDidBeginEditing(textView: UITextView) {
        if messageField.text == "Type your message here"{
            messageField.text = ""
        }
    }
    /** Replaces the default text in the text view if there is no user input*/
    func textViewDidEndEditing(textView: UITextView) {
        if messageField.text == ""{
            messageField.text = "Type your message here"
        }
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == nameField && nameField.text == "Enter your name"{
            nameField.text = ""
        }
        if textField == phoneField && phoneField.text == "Receiving number"{
            phoneField.text = ""
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == nameField && nameField.text == ""{
            nameField.text = "Enter your name"
        }
        else{
            name = nameField.text!
        }
        if textField == phoneField && phoneField.text == ""{
            phoneField.text = "Receiving number"
        }
    }
    
    
}