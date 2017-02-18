//
//  AQGeofence.swift
//  AquaManager
//
//  Created by Anton on 2/9/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreData
import CoreLocation

class AQGeofence: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var radius: Float
    @NSManaged var isCircle: Bool
    @NSManaged var centerLat: Double
    @NSManaged var centerLon: Double

    
    func getName() -> String {
        if name != nil {
            return name!
        }
        return ""
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }
    
    func getSize() -> Int {
        return Int(self.radius * self.radius * Float(M_PI))
    }
}
