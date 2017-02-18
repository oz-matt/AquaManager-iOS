//
//  AQManager.swift
//  AquaManager
//
//  Created by Anton on 2/11/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import UIKit

class AQManager {
    static let manager = AQManager()
    
    func isIpad() -> Bool {

        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return false
        case .pad:
            return true
        default:
            return false
        }
        return false
    }
    
    func refreshAllData() {
        AQNotificationsManager.manager.reloadNotifications()
        AQDeviceManager.manager.reloadDevices()
        AQGeofenceManager.manager.reloadGeofences()
    }
}
