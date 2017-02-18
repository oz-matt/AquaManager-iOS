//
//  AQGeofence+Operations.swift
//  AquaManager
//
//  Created by Anton on 2/9/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreData

extension AQGeofence {
    static func createNewGeofence(name: String) -> AQGeofence {
        let entity =  NSEntityDescription.entity(forEntityName: "AQGeofence", in:AQCoreDataManager.manager.managedObjectContext)
        
        let geofence = NSManagedObject(entity: entity!, insertInto: AQCoreDataManager.manager.managedObjectContext) as! AQGeofence
        geofence.name = name
        AQCoreDataManager.manager.saveContext()
        return geofence
    }
    
    static func ifGeofenceExists(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQGeofence")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let geofences = results as! [NSManagedObject]
            if geofences.count > 0 {
                return true
            }
            else {
                return false
            }
        } catch let _ as NSError {
            return false
        }
    }
    
    static func fetchGeofenceByName(name: String) -> AQGeofence? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQGeofence")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let geofences = results as! [NSManagedObject]
            if geofences.count > 0 {
                return geofences.first! as? AQGeofence
            }
            else {
                return nil
            }
        } catch let _ as NSError {
            return nil
        }
    }
    
    static func fetchAllGeofences() -> [AQGeofence] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQGeofence")
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                return devices as! [AQGeofence]
            }
            else {
                return [AQGeofence]()
            }
        } catch let _ as NSError {
            return [AQGeofence]()
        }
    }
    
    static func removeGeofence(geofence: AQGeofence) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQGeofence")
        fetchRequest.predicate = NSPredicate(format: "name == %@", geofence.getName())
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                AQCoreDataManager.manager._managedObjectContext?.delete(devices[0])
                AQCoreDataManager.manager.saveContext()
            }
            else {
            }
        } catch let _ as NSError {
        }
    }
}
