//
//  AQAuthRequest.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQAuthRequest: Mappable {
    var reqtype: String?
    var id: String?
    var pass: String?
    var iid: String?
    
    init() {
       reqtype = "auth"
       iid = "12341234123412341234"
    }

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.reqtype <- map["reqtype"]
        self.id <- map["id"]
        self.pass <- map["pass"]
        self.iid <- map["iid"]
    }
}

class AQAqsenRequest: Mappable {
    var reqtype: String?
    var aquakey: String?
    var pass: String?
    var iid: String?
    
    init() {
        reqtype = "getaqsen"
        iid = "12341234123412341234"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.reqtype <- map["reqtype"]
        self.aquakey <- map["aquakey"]
        self.pass <- map["pass"]
        self.iid <- map["iid"]
    }
}
