//
//  AQSensData.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

class AQSensData: Mappable {
    var datetime: String?
    var uuid: String?
    var incomingIp: String?
    var installId: String?
    
    var gpsMinimum: AQGPSMinimumData?
    var gpsExtended: AQGPSExtendedData?
    var sensorsData: AQSensorsData?
    var customData: AQSensCustomData?
    var bleData: AQBleData?
    
    init() {

    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.datetime <- map["datetime"]
        self.uuid <- map["uuid"]
        self.incomingIp <- map["incoming_ip"]
        self.installId <- map["install_id"]
        self.gpsMinimum <- map["gpsminimum"]
        self.gpsExtended <- map["gpsextended"]
        self.sensorsData <- map["sensors"]
        self.customData <- map["custom"]
        self.bleData <- map["ble"]
    }
    
    func getBatteryValue() -> Int? {
        return sensorsData?.pctBattery
    }
    
    func getSnippet() -> String? {
        if gpsMinimum != nil {
           var snippet = ""
           snippet = AQUtils.getTitleDate(date: self.getDate())
            if gpsMinimum!.gspeed != nil {
               snippet += "\nGoing \(gpsMinimum!.gspeed!)mph"
            }
            if gpsMinimum!.numsat != nil {
                snippet += "\n\(gpsMinimum!.numsat!) satellites in view"
            }
            if getBatteryValue() != nil {
                snippet += "\n\(getBatteryValue()!)% battery"
            }
            return snippet
        }
        return nil
    }
    
    func getLocation() -> CLLocationCoordinate2D? {
        let lat: Float? = gpsMinimum?.lat
        let lon: Float? = gpsMinimum?.lon
        if lat != nil && lon != nil {
           return CLLocationCoordinate2D(latitude: Double(lat!), longitude: Double(lon!))
        }
        return nil
    }
    
    func getDate() -> Date {
        let date = Date()
        var dateTime = datetime
        if gpsMinimum != nil && gpsMinimum!.time != nil {
            dateTime = gpsMinimum!.time
        }
        if dateTime != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
            let dateObj = dateFormatter.date(from: dateTime!)
            
            return dateObj!
        }
        return date
    }
}

class AQGPSMinimumData: Mappable {
    var time: String?
    var numsat: Int?
    var lon: Float?
    var lat: Float?
    var height: Float?
    var gspeed: Float?
    var direction: Float?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.time <- map["time"]
        self.numsat <- map["numsat"]
        self.lon <- map["lon"]
        self.lat <- map["lat"]
        self.height <- map["height"]
        self.gspeed <- map["gspeed"]
        self.direction <- map["direction"]
    }
}

class AQSensorsData: Mappable {
    var pctBattery: Int?
    var accelerometer: String?
    var temperature: String?
    var humidity: Int?
    var pressure: Int?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.pctBattery <- map["pct_battery"]
        self.accelerometer <- map["accelerometer"]
        self.temperature <- map["temperature"]
        self.humidity <- map["humidity"]
        self.pressure <- map["pressure"]
 
    }
}

class AQGPSExtendedData: Mappable {
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}

class AQSensCustomData: Mappable {
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}

class AQBleData: Mappable {
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
}
