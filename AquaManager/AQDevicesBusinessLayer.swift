//
//  AQDevicesBusinessLayer.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import Alamofire

class AQDevicesBusinessLayer: AQApiClient {
    let apiClient: AQDevicesApiClient = AQDevicesApiClient()
    
    func registerDevice(aquaId: String, passcode: String, completion: @escaping (AQDevice?, Bool) -> Void) {
        apiClient.registerDevice(aquaId: aquaId, passcode: passcode) { (response, success) in
            if response != nil && response!.qresponse != nil {
                if response!.qresponse! == "Success" {
                    let device: AQDevice = AQDevice.createNewDevice(aquaId: aquaId)
                    device.aqsensRaw = response?.aqsens
                    device.aqsens = response?.aqsensParsed
                    device.phoneNumber = response?.qdata?.phoneNumber
                    device.aquaKey = response?.qdata?.aquakey
                    device.pass = passcode
                    AQCoreDataManager.manager.saveContext()
                    completion(device, true)
                }
                else {
                    completion(nil, false)
                }
            }
            else {
                completion(nil, false)
            }
        }
    }
    
    func refreshAQSensForDevice(device: AQDevice, completion: @escaping (Bool) -> Void) {
        apiClient.updateQSensForDevice(device: device) { (response, success) in
            if response != nil && response!.qresponse != nil {
                if response!.qresponse! == "Success" {
                    device.aqsensRaw = response!.sensDataRaw
                    device.aqsens = response!.qdata
                    AQCoreDataManager.manager.saveContext()
                    
                    completion(true)
                }
                else {
                    completion(false)
                }
            }
            else {
                 completion(false)
            }
        }
    }
}
