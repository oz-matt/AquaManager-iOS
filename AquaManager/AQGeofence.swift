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
import GoogleMaps

class AQGeofence: NSManagedObject {
    
    @NSManaged var name: String?
    @NSManaged var radius: Float
    @NSManaged var isCircle: Bool
    @NSManaged var centerLat: Double
    @NSManaged var centerLon: Double
    @NSManaged var coordinates: Data?
    
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
        if isCircle {
           return Int(self.radius * self.radius * Float(M_PI))
        }
        return calculateArea()
    }
    
    func calculateArea() -> Int {
        var path = [CLLocationCoordinate2D]()
        let coordinates = getCoordinates()
        if coordinates.count == 16 {
            path.append(CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[2], longitude: coordinates[3]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[4], longitude: coordinates[5]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[6], longitude: coordinates[7]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[8], longitude: coordinates[9]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[10], longitude: coordinates[11]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[12], longitude: coordinates[13]))
            path.append(CLLocationCoordinate2D(latitude: coordinates[14], longitude: coordinates[15]))
            
            let area = AQMapFormulas.regionArea(locations: path)/1609.344
            return Int(area)
        }
        return 0
        
    }
    
    func getCoordinates() -> [Double] {
        if self.coordinates != nil {
           let cord = NSKeyedUnarchiver.unarchiveObject(with: self.coordinates!) as? [Double]
            if cord != nil {
               return cord!
            }
        }
        return [Double]()
    }
}
