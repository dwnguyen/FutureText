//
//  MessageHandler.swift
//  futuretext
//  Singleton used to handle the storing, saving, loading, and sorting of messages
//  Created by David Nguyen on 4/12/16.
//  Copyright © 2016 David Nguyen. All rights reserved.
//

class MessageHandler{
    static let sharedInstance = MessageHandler()
    var messagesArray : Array<Message>!
    
    /** Saves the messages stored in the messagesArray*/
    func saveMessages(){
        var storedArray:Array<NSData> = []
        for message in messagesArray{
            let encodedMessage:NSData = NSKeyedArchiver.archivedDataWithRootObject(message)
            storedArray.append(encodedMessage)
        }
        NSUserDefaults.standardUserDefaults().setObject(storedArray, forKey: "messagesArray")
    }
    /** Loads the messages stored in the messagesArray*/
    func loadMessages(){
        if let storedArray = NSUserDefaults.standardUserDefaults().objectForKey("messagesArray") as? Array<NSData>{
            var decodedArray: Array<Message> = []
            for encodedMessage in storedArray{
                let decodedMessage: Message = NSKeyedUnarchiver.unarchiveObjectWithData(encodedMessage) as! Message
                decodedArray.append(decodedMessage)
            }
            messagesArray = decodedArray
            
        } else {
            messagesArray = []//Default value
        }
        
    }
    /** Sorts the messages in the messagesArray, modifiying it*/
    func orderMessages(){
        if messagesArray.count != 0 {
            for var i = 0; i < messagesArray.count; i++ {
                if messagesArray[i].sendDate.earlierDate(NSDate()) == messagesArray[i].sendDate{
                    messagesArray.removeAtIndex(i);
                }
            }
            if messagesArray.count > 1{
                var sorted = false
                while sorted == false{
                    for var y = messagesArray.count - 2; y >= 0; y-- {
                        if messagesArray[y].sendDate.earlierDate(messagesArray[y + 1].sendDate) == messagesArray[y + 1].sendDate{
                            let x = messagesArray[y + 1].sendDate
                            messagesArray[y + 1].sendDate = messagesArray[y].sendDate
                            messagesArray[y].sendDate = x
                            sorted = false
                        }
                        else{
                            sorted = true
                        }
                    }
                    
                }
            }
        }
        
    }
    
    /**
     Returns the message with the specified id number
     
     - Parameter id: Id to be searched with
     
     - Returns:Message with specified ID
     
     */
    func returnMessageWithID(id: Int) -> Message{
        for message in messagesArray{
            if message.messageID == id{
                return message
            }
        }
        return Message()
    }
    
    
}
