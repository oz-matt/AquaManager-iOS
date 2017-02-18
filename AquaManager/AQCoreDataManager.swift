//
//  AQCoreDataManager.swift
//  AquaManager
//
//  Created by Anton on 2/4/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class AQCoreDataManager: NSObject {
    
    static let manager = AQCoreDataManager()
    
    override init() {
        super.init()
    }
    
    func saveContext () {
        let managedObjectContext = self.managedObjectContext
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save")
        }
    }
    
    // #pragma mark - Core Data stack
    
    // Returns the managed object context for the application.
    // If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
    var managedObjectContext: NSManagedObjectContext {
        if _managedObjectContext != nil {
            return _managedObjectContext!
        }
        let coordinator = self.persistentStoreCoordinator
        _managedObjectContext = NSManagedObjectContext()
        if coordinator != nil {
            _managedObjectContext!.persistentStoreCoordinator = coordinator
        }
        return _managedObjectContext!
    }
    var _managedObjectContext: NSManagedObjectContext? = nil
    
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    var managedObjectModel: NSManagedObjectModel {
        if !(_managedObjectModel != nil) {
            let modelURL = Bundle.main.url(forResource: "AquaManagerModel", withExtension: "momd")
            _managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)
        }
        return _managedObjectModel!
    }
    var _managedObjectModel: NSManagedObjectModel? = nil
    
    // Returns the persistent store coordinator for the application.
    // If the coordinator doesn't already exist, it is created and the application's store added to it.
    var persistentStoreCoordinator: NSPersistentStoreCoordinator {
        if !(_persistentStoreCoordinator != nil) {
            let storeURL = self.applicationDocumentsDirectory.appendingPathComponent("AquaManagerModel.sqlite")
            var error: NSError? = nil
            _persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
            do {
                try _persistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
        return _persistentStoreCoordinator!
    }
    var _persistentStoreCoordinator: NSPersistentStoreCoordinator? = nil
    
    // #pragma mark - Application's Documents directory
    
    // Returns the URL to the application's Documents directory.
    var applicationDocumentsDirectory: NSURL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
}
