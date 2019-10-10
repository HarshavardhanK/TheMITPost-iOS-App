//
//  AppDelegate.swift
//  TheMitPost
//
//  Created by Harshavardhan K on 14/01/19.
//  Copyright © 2019 Harshavardhan K. All rights reserved.
//

import UIKit
import NotificationCenter

import Firebase
import SDWebImage

// Google Cloud client ID 1006288901885-r5qf169g9ht0mmmbj2v0o3gs5it713b5.apps.googleusercontent.com

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    

    var window: UIWindow?
    var storyBoard: UIStoryboard!
    
    let notificationType = "gcm.notification.type"
    let gcmMessageIDKey = "gcm.message_id"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        InstanceID.instanceID().instanceID { (result, error) in
            
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
            
          } else if let result = result {
            
            print("Remote instance ID token: \(result.token)")
            UserDefaults.standard.set(result.token, forKey: "token")
            
          }
            
        }

        //MARK: Subscribe to notices
        Messaging.messaging().subscribe(toTopic: "notice") { error in
          print("Subscribed to notice topic")
        }
        
        Messaging.messaging().subscribe(toTopic: "general") { error in
          print("Subscribed to general topic")
        }
        
        let notificationOption = launchOptions?[.remoteNotification]
        
        if let notification = notificationOption as? [String: Any] {
            
            print(notification)
            
            if let type = notification["gcm.notification.type"] as? String {
              
               print(type)
                
                if type == "slcm" {
                    (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
                    
                } else if type == "notice" {
                    
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: Notification.Name("notice"), object: nil)
                    
                    (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
                    
                } else if type == "event" {
                    
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: Notification.Name("event"), object: nil)
                    
                    (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
                    
                } else {
                    
                    let notificationCenter = NotificationCenter.default
                    notificationCenter.post(name: Notification.Name("article"), object: nil)
                    
                    (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
                }
            }
            
            application.applicationIconBadgeNumber = 0
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            //application.cancelAllLocalNotifications()
        }
        
        return true
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert])
        
        print("Notification received in foreground")
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        if let type = userInfo["gcm.notification.type"] as? String {
            
            print(type)
            
            if type == "slcm" {
                (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
                
            } else if type == "notice" {
                
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Notification.Name("notice"), object: nil)
                
                (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
                
            } else if type == "event" {
                
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Notification.Name("event"), object: nil)
                
                (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
                
            } else {
                
                let notificationCenter = NotificationCenter.default
                notificationCenter.post(name: Notification.Name("article"), object: nil)
                
                (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
            }
        }
        
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification
      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)
      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }
        
      if let type = userInfo["gcm.notification.type"] as? String {

        print(type)

          if type == "slcm" {
              (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
              
          } else if type == "notice" {
              
              let notificationCenter = NotificationCenter.default
              notificationCenter.post(name: Notification.Name("notice"), object: nil)
              
              (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
              
          } else if type == "event" {
              
              let notificationCenter = NotificationCenter.default
              notificationCenter.post(name: Notification.Name("event"), object: nil)
              
              (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
              
          } else {
              
              let notificationCenter = NotificationCenter.default
              notificationCenter.post(name: Notification.Name("article"), object: nil)
              
              (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
          }
      }
      print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        print(userInfo)
//
//        if let type = userInfo["gcm.notification.type"] as? String {
//
//          print(type)
//
//            if type == "slcm" {
//                (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
//
//            } else if type == "notice" {
//                (window?.rootViewController as? UITabBarController)?.selectedIndex = 2
//
//            } else if type == "event" {
//                (window?.rootViewController as? UITabBarController)?.selectedIndex = 3
//
//            } else {
//                (window?.rootViewController as? UITabBarController)?.selectedIndex = 0
//            }
//        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk {
            print("Cleared image cache")
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk {
            print("Cleared image cache")
        }
        
    }


}

