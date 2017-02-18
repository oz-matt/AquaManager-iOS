//
//  AQNotificationsBusinessLayer.swift
//  AquaManager
//
//  Created by Anton on 2/11/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import CoreLocation

class AQNotificationBusinessLayer {
    let apiClient = AQNotificationApiClient()
    
    func removeNotificationById(notId: String, name: String, completion: @escaping (String, Bool) -> Void) {
        apiClient.removeNotificationById(notId: notId, deviceName: name) { (response, success) in
            if success {
                if response != nil {
                    if response!.getStringResponse() == "Success" {
                        completion("", true)
                    }
                    else {
                       completion(response!.getStringResponse(), false)
                    }
                }
                else {
                    completion("Server Error", false)
                }
            }
            else {
                completion("Server Error", false)
            }
        }
    }
    
    func insertNotificationSimple(not: AQTempNotification, completion: @escaping (String, Bool) -> Void) {
        let request: AQBaseNotificationRequest = AQBaseNotificationRequest()
        request.aquakey = not.device?.aquaKey
        let data: AQNotificationDataRequest = AQNotificationDataRequest()
        request.data = data
        data.alert = not.alarm.rawValue
        data.aquaname = not.device?.getName()
        data.target = not.target
        data.trigger = not.trigger.rawValue
        data.continuous = not.continuous
        
        self.insertNotification(request: request, completion: completion)
    }
    
    func insertNotificationSimpleGeofenceCircle(not: AQTempNotification, completion: @escaping (String, Bool) -> Void) {
        let request: AQBaseNotificationRequest = AQBaseNotificationRequest()
        request.aquakey = not.device?.aquaKey
        let data: AQNotificationDataWithGeofenceCircle = AQNotificationDataWithGeofenceCircle()
        request.data = data
        data.alert = not.alarm.rawValue
        data.aquaname = not.device?.getName()
        data.target = not.target
        data.trigger = not.trigger.rawValue
        data.continuous = not.continuous
        data.geoname = not.geofence?.getName()
        if not.geofence?.isCircle == true {
           data.geotype = "circle"
        }
        else {
           data.geotype = "polygon"
        }
        if let geofence = not.geofence {
            data.geodata = ["\(geofence.centerLat)", "\(geofence.centerLon)", "\(geofence.radius)"]
        }
        
        self.insertNotification(request: request, completion: completion)
    }
    
    func insertNotificationSimpleGeofencePolygon(not: AQTempNotification, completion: @escaping (String, Bool) -> Void) {
        let request: AQBaseNotificationRequest = AQBaseNotificationRequest()
        request.aquakey = not.device?.aquaKey
        let data: AQNotificationDataWithGeofencePolygon = AQNotificationDataWithGeofencePolygon()
        request.data = data
        data.alert = not.alarm.rawValue
        data.aquaname = not.device?.getName()
        data.target = not.target
        data.trigger = not.trigger.rawValue
        data.continuous = not.continuous
        data.geoname = not.geofence?.getName()
        if not.geofence?.isCircle == true {
            data.geotype = "circle"
        }
        else {
            data.geotype = "polygon"
        }
        if let geofence = not.geofence {
            let loc = CLLocationCoordinate2D(latitude: geofence.centerLat, longitude: geofence.centerLon)
            let box = AQUtils.getBoundingBox(coordinate: loc, radius: Double(geofence.radius))
            data.geodata = ["pt1_lat":0,
                            "pt1_lon":0,
                            "pt2_lat":0,
                            "pt2_lon":0,
                            "pt3_lat":0,
                            "pt3_lon":0,
                            "pt4_lat":0,
                            "pt4_lon":0,
                            "pt5_lat":0,
                            "pt5_lon":0,
                            "pt6_lat":0,
                            "pt6_lon":0,
                            "pt7_lat":0,
                            "pt7_lon":0,
                            "pt8_lat":0,
                            "pt8_lon":0,
            ]
        }
        
        self.insertNotification(request: request, completion: completion)
    }

    
    func insertNotification(request: AQBaseNotificationRequest, completion: @escaping (String, Bool) -> Void) {
        apiClient.postNotification(notification: request) { (result, success) in
            if success {
                if result != nil {
                    if result!.getStringResponse() == "Success" {
                        completion("Success", true)
                    }
                    else {
                        completion(result!.getStringResponse(), false)
                    }
                }
                else {
                    completion(result!.getStringResponse(), false)
                }
            }
            else {
                completion("Server error", false)
            }
            
        }
    }
}
