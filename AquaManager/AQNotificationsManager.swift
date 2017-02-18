//
//  AQNotificationsManager.swift
//  AquaManager
//
//  Created by Anton on 2/15/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation

class AQNotificationsManager {
    static let manager = AQNotificationsManager()
    
    var notifications: [AQNotification] = [AQNotification]()
    
    func createNewNotification(temp: AQTempNotification) {
        let not = AQNotification.createNewNotification(temp: temp)
        notifications.append(not)
    }
    
    func reloadNotifications() {
        notifications = AQNotification.fetchAllNotifications()
    }
    
}
