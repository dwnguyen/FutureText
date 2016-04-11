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
        if AppDelegate.getAppDelegate().messagesArray.count != 0 {
            for var i = 0; i < AppDelegate.getAppDelegate().messagesArray.count; i++ {
                if AppDelegate.getAppDelegate().messagesArray[i].sendDate.earlierDate(NSDate()) == AppDelegate.getAppDelegate().messagesArray[i].sendDate{
                    AppDelegate.getAppDelegate().messagesArray.removeAtIndex(i);
                }
            }
            if AppDelegate.getAppDelegate().messagesArray.count > 1{
                var sorted = false
                while sorted == false{
                    for var y = AppDelegate.getAppDelegate().messagesArray.count - 2; y >= 0; y-- {
                        if AppDelegate.getAppDelegate().messagesArray[y].sendDate.earlierDate(AppDelegate.getAppDelegate().messagesArray[y + 1].sendDate) == AppDelegate.getAppDelegate().messagesArray[y + 1].sendDate{
                            let x = AppDelegate.getAppDelegate().messagesArray[y + 1].sendDate
                            AppDelegate.getAppDelegate().messagesArray[y + 1].sendDate = AppDelegate.getAppDelegate().messagesArray[y].sendDate
                            AppDelegate.getAppDelegate().messagesArray[y].sendDate = x
                            sorted = false
                        }
                        else{
                            sorted = true
                        }
                    }
                    
                }
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

