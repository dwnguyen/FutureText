//
//  MessagesViewController.swift
//  Presents all pending messages in a sorted table view
//
//  Created by David Nguyen on 4/6/16.
//
//

import UIKit
import Foundation
@available(iOS 9.0, *)
class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var messagesTable: UITableView!
    //Sets delegates when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTable.delegate = self
        messagesTable.dataSource = self
        messagesTable.allowsSelection = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    //orders messages when the view will appear
    override func viewWillAppear(animated: Bool) {
        MessageHandler.sharedInstance.orderMessages()
        messagesTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Sets the number of table view cells to the number of messages in the messagesArray
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageHandler.sharedInstance.messagesArray.count
    }
    //Creates a table view cell based on the corresponding message from the messagesArray
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.messagesTable.dequeueReusableCellWithIdentifier("cell") as! MessageTableCell
        let currentMessage = MessageHandler.sharedInstance.messagesArray[indexPath.row]
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

