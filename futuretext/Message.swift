//
//  Message.swift
//  futuretext
//
//  Created by David Nguyen on 4/6/16.
//  Copyright © 2016 David Nguyen. All rights reserved.
//

class Message{
    var senderName: String!
    var receivingNumber: String = "hohoi"
    var receivingName: String!
    var message: String!
    var sendDate: NSDate!
    
    init(senderName: String, receivingNum: String, receivingName: String, message: String, sendDate: NSDate){
        self.senderName = senderName
        
        self.receivingName = receivingName
        self.message = message
        self.sendDate = sendDate
        self.receivingNumber = receivingNum
    }
}
