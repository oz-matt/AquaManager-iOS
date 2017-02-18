//
//  AQBaseNotificationRequest.swift
//  AquaManager
//
//  Created by Anton on 2/16/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQBaseNotificationRequest: Mappable {
    var reqtype: String?
    var aquakey: String?
    var iid: String?
    var data: AQNotificationDataRequest?
    
    init() {
        reqtype = "notif"
        iid = "12341234123412341234"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.reqtype <- map["reqtype"]
        self.aquakey <- map["aquakey"]
        self.iid <- map["iid"]
        self.data <- map["data"]
    }
}

class AQNotificationDataRequest: Mappable {
    var alert: String?
    var aquaname: String?
    var ntfuuid: String?
    var target: String?
    var trigger: String?
    var continuous: Bool?
    
    init() {
        self.ntfuuid = "abcdefghi-qwerfeqrf-qerf"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.alert <- map["alert"]
        self.aquaname <- map["aquaname"]
        self.ntfuuid <- map["ntfuuid"]
        self.target <- map["target"]
        self.trigger <- map["trigger"]
        self.continuous <- map["continuous"]
    }
}

class AQNotificationDataWithGeofenceCircle: AQNotificationDataRequest {
    var geotype: String?
    var geoname: String?
    var geodata: [String]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.geotype <- map["geotype"]
        self.geoname <- map["geoname"]
        self.geodata <- map["geodata"]
    }
}

class AQNotificationDataWithGeofencePolygon: AQNotificationDataRequest {
    var geotype: String?
    var geoname: String?
    var geodata: [String: Double]?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        self.geotype <- map["geotype"]
        self.geoname <- map["geoname"]
        self.geodata <- map["geodata"]
    }
}
