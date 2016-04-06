//
//  AppDelegate.swift
//  futuretext
//
//  Created by David Nguyen on 1/16/16.
//  Copyright (c) 2016 David Nguyen. All rights reserved.
//

import UIKit
import Contacts

@available(iOS 9.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /** Handles the user's contacts*/
    var contactStore = CNContactStore()
    var coder = NSCoder()
    var messagesArray : Array<Message> = []
    
        /**{
            get {
                if let storedArray = NSUserDefaults.standardUserDefaults().objectForKey("messagesArray") as? Array<NSData>{
                    var decodedArray: Array<Message> = []
                    for encodedMessage in storedArray{
                        let decodedMessage: Message = NSKeyedUnarchiver.unarchiveObjectWithData(encodedMessage) as! Message
                        decodedArray.append(decodedMessage)
                    }
                    print(decodedArray)
                    return decodedArray
                    
                } else {
                    return []//Default value
                }
            }
            set {
                var storedArray:Array<NSData> = []
                for message in messagesArray{
                    let encodedMessage:NSData = NSKeyedArchiver.archivedDataWithRootObject(message)
                    storedArray.append(encodedMessage)
                }
                
                NSUserDefaults.standardUserDefaults().setObject(storedArray, forKey: "messagesArray")
            }
    } */

    var window: UIWindow?
    
    /** 
     
     Getter method for AppDelegate
     
    - Returns:AppDelegate
     
     */
    class func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    func checkContactAccess() -> Bool{
        let authorization = CNContactStore.authorizationStatusForEntityType(CNEntityType.Contacts)
        if authorization == .Authorized{
            return true
        }
        else{
            return false
        }
    }
    
    func requestContactAccess(){
        self.contactStore.requestAccessForEntityType(CNEntityType.Contacts, completionHandler: {(accessGranted, accessError) -> Void in
            if accessGranted == false{
                let alert = UIAlertController(title: "Contacts", message:
                    "Please enable contacts in settings if you want to send messages to your contacts", preferredStyle: UIAlertControllerStyle.Alert)
                let dismiss = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(dismiss)
                let vc = self.window!.rootViewController;
                vc?.presentViewController(alert, animated: true, completion: nil)
                
            }
        })

        
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

