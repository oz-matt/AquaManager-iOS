//
//  AQNotification+Operations.swift
//  AquaManager
//
//  Created by Anton on 2/15/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreData

extension AQNotification {
    static func createNewNotification(temp: AQTempNotification) -> AQNotification {
        let entity =  NSEntityDescription.entity(forEntityName: "AQNotification", in:AQCoreDataManager.manager.managedObjectContext)
        
        let notification = NSManagedObject(entity: entity!, insertInto: AQCoreDataManager.manager.managedObjectContext) as! AQNotification
        notification.alert = temp.alarm.rawValue
        notification.aquaname = temp.device!.getName()
        notification.target = temp.target
        notification.continuous = temp.continuous
        notification.trigger = temp.trigger.rawValue
        notification.aquakey = temp.device?.aquaKey
        notification.ntfuuid = temp.notId
        if temp.geofence != nil {
            if temp.geofence!.isCircle {
               notification.geotype = "circle"
            }
            else {
               notification.geotype = "polygon"
            }
            notification.geoname = temp.geofence?.name
        }
        
        AQCoreDataManager.manager.saveContext()
        return notification
    }
    
    
    static func fetchAllNotifications() -> [AQNotification] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQNotification")
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                return devices as! [AQNotification]
            }
            else {
                return [AQNotification]()
            }
        } catch let _ as NSError {
            return [AQNotification]()
        }
    }
    
    static func removeNotification(uniqueId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQNotification")
        fetchRequest.predicate = NSPredicate(format: "ntfuuid == %@", uniqueId)
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let nots = results as! [NSManagedObject]
            if nots.count > 0 {
                AQCoreDataManager.manager._managedObjectContext?.delete(nots[0])
                AQCoreDataManager.manager.saveContext()
            }
            else {
            }
        } catch let _ as NSError {
        }
    }
}
