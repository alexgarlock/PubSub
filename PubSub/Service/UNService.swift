//
//  UNService.swift
//  Remind
//
//  Created by Alex Garlock
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No UN auth error")
            guard granted else {
                print("USER DENIED ACCESS")
                return
            }
            
            self.configure()
//     Set the day to wendesday to notify the user about the new sub of the week.
            var components = DateComponents()
            //starts on Wedensday (= 4) and goes off at hour (=11AM)
            components.weekday = 4
            components.hour = 11
            UNService.shared.dateRequest(with: components)
        }
        
    }
    
    func configure() {
        unCenter.delegate = self
        setupActionsAndCategories()
    }
    
    func setupActionsAndCategories() {

        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue,
                                               title: "Run date logic",
                                               options: [.destructive])
        
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue,
                                                   actions: [dateAction],
                                                   intentIdentifiers: [])
        
        unCenter.setNotificationCategories([dateCategory])
    }
    
    
    func dateRequest(with components: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = "Pub Sub"
        content.body = "It is now time for the Sub of the week at PubSub"
        content.sound = .default()
        content.badge = 1
        content.categoryIdentifier = NotificationCategory.date.rawValue
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "userNotification.date",
                                            content: content,
                                            trigger: trigger)
        unCenter.add(request)
    }
    
}

extension UNService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"),
                                            object: action)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN WILL present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}
