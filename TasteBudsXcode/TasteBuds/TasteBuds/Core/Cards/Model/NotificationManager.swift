//
//  NotificationManager.swift
//  TasteBuds
//
//  Created by Alyssa Aragon on 4/8/25.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permissions granted.")
            } else if let error = error {
                print("There was an error requesting notifications: \(error.localizedDescription)")
            } else {
                print("Notification permissions denied.")
            }
        }
    }
}
