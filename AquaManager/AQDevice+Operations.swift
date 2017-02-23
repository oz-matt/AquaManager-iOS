//
//  AQDevice+Operations.swift
//  AquaManager
//
//  Created by Anton on 2/4/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension AQDevice {
    static func fetchAQDevice(deviceId: String) -> AQDevice? {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQDevice")
        fetchRequest.predicate = NSPredicate(format: "aquaId == %@", deviceId)
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                return devices[0] as! AQDevice
            }
            else {
                return nil
            }
        } catch let _ as NSError {
            return nil
        }
    }
    
    static func fetchAllDevices() -> [AQDevice] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQDevice")
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                return devices as! [AQDevice]
            }
            else {
                return [AQDevice]()
            }
        } catch let _ as NSError {
            return [AQDevice]()
        }
    }
    
    static func createNewDevice(aquaId: String) -> AQDevice {
        let entity =  NSEntityDescription.entity(forEntityName: "AQDevice", in:AQCoreDataManager.manager.managedObjectContext)
        
        let device = NSManagedObject(entity: entity!, insertInto: AQCoreDataManager.manager.managedObjectContext) as! AQDevice
        device.aquaId = aquaId
        AQCoreDataManager.manager.saveContext()
        return device
    }
    
    static func updateDevice(device: AQDevice) {
        AQCoreDataManager.manager.saveContext()
    }
    
    
    static func ifDeviceExists(deviceId: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQDevice")
        fetchRequest.predicate = NSPredicate(format: "aquaId == %@", deviceId)
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                return true
            }
            else {
                return false
            }
        } catch let _ as NSError {
            return false
        }
    }
    
    static func ifDeviceNameExists(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQDevice")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try AQCoreDataManager.manager.managedObjectContext.fetch(fetchRequest)
            let devices = results as! [NSManagedObject]
            if devices.count > 0 {
                return true
            }
            else {
                return false
            }
        } catch let _ as NSError {
            return false
        }
    }
    
    static func removeDevice(deviceId: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AQDevice")
        fetchRequest.predicate = NSPredicate(format: "aquaId == %@", deviceId)
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

