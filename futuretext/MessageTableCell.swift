//
//  MessageTableCell.swift
//  Formats the table view cell that is used to display queued messages to the user
//
//  Created by David Nguyen on 4/6/16.
//
//

import Foundation

class MessageTableCell: UITableViewCell{
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
}