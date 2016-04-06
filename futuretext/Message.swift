//
//  Message.swift
//  futuretext
//
//  Created by David Nguyen on 4/6/16.
//  Copyright © 2016 David Nguyen. All rights reserved.
//

class Message: NSObject, NSCoding{
    var senderName: String!
    var receivingNumber: String!
    var receivingName: String!
    var message: String!
    var sendDate: NSDate!
    
    required init(senderName: String, receivingNum: String, receivingName: String, message: String, sendDate: NSDate){
        self.senderName = senderName
        
        self.receivingName = receivingName
        self.message = message
        self.sendDate = sendDate
        self.receivingNumber = receivingNum
    }
    required init(coder aDecoder: NSCoder) {
        senderName = aDecoder.decodeObjectForKey("senderName") as! String
        receivingNumber = aDecoder.decodeObjectForKey("receivingNumber") as! String
        receivingName = aDecoder.decodeObjectForKey("receivingName") as! String
        message = aDecoder.decodeObjectForKey("message") as! String
        sendDate = aDecoder.decodeObjectForKey("sendDate") as! NSDate
        
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(senderName, forKey: "senderName")
        aCoder.encodeObject(receivingNumber, forKey: "receivingNumber")
        aCoder.encodeObject(receivingName, forKey: "receivingName")
        aCoder.encodeObject(message, forKey: "message")
        aCoder.encodeObject(sendDate, forKey: "sendDate")
    }
}
