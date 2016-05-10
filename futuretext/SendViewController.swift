//
//  SendViewController.swift
//  futuretext
//
//  Created by David Nguyen on 4/6/16.
//  Copyright © 2016 David Nguyen. All rights reserved.
//

import UIKit
import MessageUI
import mailgun
import ContactsUI


@available(iOS 9.0, *)
class SendViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, CNContactPickerDelegate {
    
    @IBOutlet weak var receiverLabel: UILabel!
    /** Takes user input for the user's name*/
    @IBOutlet weak var nameField: UITextField!
    /** Takes user input for the message to be sent*/
    @IBOutlet weak var messageField: UITextView!
    /** Takes user input for number to which the message is sent*/
    @IBOutlet weak var phoneField: UITextField!
    /** Takes user input for the date at which the message is sent*/
    @IBOutlet weak var datePicker: UIDatePicker!
    
    /** Stores the name of the user when it is changed, and gets this value when necessary*/
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
    /**
     This method is called when the view loads. It assigns delegates and resets text. Also adds a gesture so that the keyboard can be dismissed
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        receiverLabel.text = ""
        nameField.text = name
        messageField.editable = true
        nameField.delegate = self
        phoneField.delegate = self
        messageField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    /** dismisses keyboard) */
    func dismissKeyboard() {
        view.endEditing(true)
    }
    /**
     Sends a text by emailing service provider when linked button is pressed.
     Uses the provided name and phone number from the text fields. Also creates
     a message object to store the info passed when sending.
     
     - Parameter sender:   The button that calls the method (Send to Future)
     */
    @IBAction func sendText(sender: UIButton) {
        let mailgun: Mailgun = Mailgun.clientWithDomain("sandboxb5df4d368c4c472ea05844e6da828448.mailgun.org", apiKey: "key-eb644fc9dafb391e4135512567198c7d")
        let seconds = datePicker.date.timeIntervalSinceNow - 60
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        print(MessageHandler.sharedInstance.messagesArray.count)
        var numberString = phoneField.text!
        // this looks ridiculous but I have not found another way to do this because the String.index is not convertible to an int. I need this to substring the phone number so that only 10 digits are inputted
        let index = numberString.endIndex.predecessor().predecessor().predecessor().predecessor().predecessor().predecessor().predecessor().predecessor().predecessor().predecessor()
        numberString = numberString.substringFromIndex(index)
        let message = Message(senderName: nameField.text!, receivingNum: numberString, receivingName: receiverLabel.text!, message: messageField.text, sendDate: datePicker.date)
        let id = message.messageID
        MessageHandler.sharedInstance.messagesArray.append(message)
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            let sentMessage = MessageHandler.sharedInstance.returnMessageWithID(id)
            if sentMessage.shouldSend{
                mailgun.sendMessageTo("receiver <" + numberString + "@txt.att.net>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
                mailgun.sendMessageTo("receiver <" + numberString + "@vtext.com>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
                mailgun.sendMessageTo("receiver <" + numberString + "@tmomail.net>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
                mailgun.sendMessageTo("receiver <" + numberString + "@messaging.sprintpcs.com>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
                print("Message Sent")
            }
            else{
                print("Message was canceled")
            }
            
        })
        
        
        let alert = UIAlertController(title: "Message", message:
            "Message Queued", preferredStyle: UIAlertControllerStyle.Alert)
        let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    /**
     Checks if access is granted to contacts and calls the presentContacts method if access is granted or asks for access if not granted
     
     - Parameter sender:   The button that calls the method (Choose from Contacts)
     
     
     */
    @IBAction func viewContacts(sender: AnyObject) {
        if !AppDelegate.getAppDelegate().checkContactAccess(){
            AppDelegate.getAppDelegate().requestContactAccess()
            if AppDelegate.getAppDelegate().checkContactAccess(){
                presentContacts()
            }
        }
        else{
            presentContacts()
        }
    }
    
    /**
     Presents the view in which a contacts number can be selected.
     */
    func presentContacts(){
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.displayedPropertyKeys =
            [CNContactPhoneNumbersKey]
        self.presentViewController(contactPicker, animated: true, completion: nil)
    }
    
    /**
     Allows the user to select a number then sets the poneField text and receiverLabel text appropiately when a contact's number is selected
     */
    func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
        phoneField.text = contactProperty.value!.valueForKey("digits")! as! String
        receiverLabel.text = contactProperty.contact.givenName + " " + contactProperty.contact.familyName
    }
    /**
     Called when the view is about to disappear. Makes sure that the navigation bar remains visible.
     */
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
    var originalText = ""
    /**Clears fields appropiately when a user starts editing them*/
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == nameField && nameField.text == "Enter your name"{
            nameField.text = ""
        }
        if textField == phoneField && phoneField.text == "Receiving number?"{
            phoneField.text = ""
        }
        else{
            originalText = phoneField.text!
        }
    }
    /** Resets fields when user stops editing them*/
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == nameField && nameField.text == ""{
            nameField.text = "Enter your name"
        }
        else{
            name = nameField.text!
        }
        if textField == phoneField && phoneField.text == ""{
            phoneField.text = "Receiving number?"
        }
        else if phoneField.text! != originalText{
            receiverLabel.text = ""
        }
    }
}