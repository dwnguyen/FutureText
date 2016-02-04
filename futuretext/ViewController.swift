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

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var messageField: UITextView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    var name = "";
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func sendText(sender: UIButton) {
        let mailgun: Mailgun = Mailgun.clientWithDomain("samples.mailgun.org", apiKey: "key-3ax6xnjp29jd6fds4gc373sgvjxteol0")
        let seconds = datePicker.date.timeIntervalSinceNow - 60
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        print(seconds)
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            mailgun.sendMessageTo("Reciever <" + self.phoneField.text! + "@txt.att.net>", from: self.nameField.text! + "<someone@sample.org>", subject: "", body: self.messageField.text! + "\n This message was sent using futuretext")
            print("Message Sent")
            
        })
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if messageField.text == "Type your message here"{
            messageField.text = ""
        }
    }
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
        if textField == phoneField && phoneField.text == ""{
            phoneField.text = "Receiving number"
        }
    }
    
}
