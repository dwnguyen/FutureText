//
//  MessagesViewController.swift
//  
//
//  Created by David Nguyen on 4/6/16.
//
//

import UIKit
import Foundation
@available(iOS 9.0, *)
class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var messagesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTable.delegate = self
        messagesTable.dataSource = self
        messagesTable.allowsSelection = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        for var i = 0; i < AppDelegate.getAppDelegate().messagesArray.count; i++ {
            if AppDelegate.getAppDelegate().messagesArray[i].sendDate.earlierDate(NSDate()) == AppDelegate.getAppDelegate().messagesArray[i].sendDate{
                AppDelegate.getAppDelegate().messagesArray.removeAtIndex(i);
            }
        }
        messagesTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDelegate.getAppDelegate().messagesArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messagesTable.dequeueReusableCellWithIdentifier("cell") as! MessageTableCell
        let currentMessage = AppDelegate.getAppDelegate().messagesArray[indexPath.row]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mma MM/dd/yyyy"
        cell.timeLabel.text = dateFormatter.stringFromDate(currentMessage.sendDate)
        cell.nameLabel.text = currentMessage.receivingName
        cell.numberLabel.text = currentMessage.receivingNumber
        cell.messageTextView.text = currentMessage.message
        cell.messageTextView.editable = false
        
        return cell
    }

    
}

