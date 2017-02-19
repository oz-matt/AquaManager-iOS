//
//  AQNotification.swift
//  AquaManager
//
//  Created by Anton on 2/15/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreData

enum AQTrigger: String {
    case lowBattery = "lowBattery"
    case enterGeofence = "entersGeo"
    case exitGeofence = "exitsGeo"
    case uploadsData = "uploadsData"
    case seesMac = "seesMac"
    case startMoving = "startsMoving"
    case stopsMoving = "stopsMoving"
    case unknown = "Unknown"
}

class AQNotification: NSManagedObject {
    @NSManaged var alert: String?
    @NSManaged var aquaname: String?
    @NSManaged var ntfuuid: String?
    @NSManaged var target: String?
    @NSManaged var trigger: String?
    @NSManaged var continuous: Bool
    @NSManaged var geotype: String?
    @NSManaged var geoname: String?
    @NSManaged var geodata: String?
    @NSManaged var aquakey: String?
    @NSManaged var localId: Int
    
    func getUniqueId() -> String {
        if ntfuuid == nil {
            return ""
        }
        return ntfuuid!
    }
    
    func getAquaName() -> String {
        if aquaname != nil {
            return aquaname!
        }
        return ""
    }
}
