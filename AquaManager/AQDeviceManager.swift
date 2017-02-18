//
//  AQDeviceManager.swift
//  AquaManager
//
//  Created by Anton on 2/4/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation

class AQDeviceManager {
    static let manager = AQDeviceManager()
    var deviceLayer: AQDevicesBusinessLayer = AQDevicesBusinessLayer()
    var devices: [AQDevice] = [AQDevice]()
    
    func isDeviceAdded(deviceId: String) -> Bool {
        return true
    }
    
    func reloadDevices() {
        let newDevices = AQDevice.fetchAllDevices()
        for dev in newDevices {
            var exist: Bool = false
            for old in devices {
                if old.aquaId! == dev.aquaId! {
                   exist = true
                   break
                }
            }
            if !exist {
               dev.refillDeviceSens()
               devices.append(dev)
            }
        }
    }
    
    func removeDevice(device: AQDevice) {
        if device.aquaId != nil {
           AQDevice.removeDevice(deviceId: device.aquaId!)
        }
        var indexToRemove: Int = -1
        var index: Int = 0
        for dev in devices {
            if device.aquaId == dev.aquaId {
               indexToRemove = index
               break
            }
            index += 1
        }
        if indexToRemove != -1 {
           devices.remove(at: indexToRemove)
        }
    }
    
    func reloadDeviceData(index: Int, completion: @escaping () -> ()) {
        if index < devices.count {
           let dev = devices[index]
           deviceLayer.refreshAQSensForDevice(device: dev, completion: { (success) in
                completion()
           })
        }
        else {
            completion()
        }
    }
}
