//
//  AQMapFormulas.swift
//  AquaManager
//
//  Created by test on 2/23/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreLocation

class AQMapFormulas {
    static let kEarthRadius = 6378137.0
    
    static func radians(degrees: Double) -> Double {
        return degrees * M_PI / 180;
    }
    
    static func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
        
        guard locations.count > 2 else { return 0 }
        var area = 0.0
        
        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]
            
            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        area = -(area * kEarthRadius * kEarthRadius / 2);
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
}
