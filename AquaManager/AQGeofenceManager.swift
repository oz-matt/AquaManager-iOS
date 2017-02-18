//
//  AQGeofenceManager.swift
//  AquaManager
//
//  Created by Anton on 2/9/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation

class AQGeofenceManager {
    static let manager = AQGeofenceManager()
    
    var geofences: [AQGeofence] = [AQGeofence]()
    
    func reloadGeofences() {
        geofences = AQGeofence.fetchAllGeofences()
    }
    
    

}
