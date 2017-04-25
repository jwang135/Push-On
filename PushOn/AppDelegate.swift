//
//  AppDelegate.swift
//  PushOn
//
//  Created by Rishil on 4/14/17.
//  Copyright © 2017 Rishil Mehta. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        return true
    }

    private func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        print("Tapped in notification")
        let actionIdentifier = response.actionIdentifier
        if actionIdentifier == "com.apple.UNNotificationDefaultActionIdentifier" || actionIdentifier == "com.apple.UNNotificationDismissActionIdentifier" {
            return;
        }
        let accept = (actionIdentifier == "Accept")
        let cancel = (actionIdentifier == "Cancel")
        
        repeat {
            if (accept) {
                let title = "Accept"
                self.addLabel(title: title, color: UIColor.yellow)
                break;
            }
            if (cancel) {
                let title = "Cancel";
                self.addLabel(title: title, color: UIColor.red)
                break;
            }
            
        } while (false);
        // Must be called when finished
        completionHandler();
    }
    
    private func addLabel(title: String, color: UIColor) {
        let label = UILabel.init()
        label.backgroundColor = UIColor.red
        label.text = title
        label.sizeToFit()
        label.backgroundColor = color
        let centerX = UIScreen.main.bounds.width * 0.5
        let centerY = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.height)))
        label.center = CGPoint(x: centerX, y: centerY)
        self.window!.rootViewController!.view.addSubview(label)
    }

    private func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        print("Notification being triggered")
        // Must be called when finished, when you do not want to show in foreground, pass [] to the completionHandler()
        completionHandler(UNNotificationPresentationOptions.alert)
        // completionHandler( UNNotificationPresentationOptions.sound)
        // completionHandler( UNNotificationPresentationOptions.badge)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

