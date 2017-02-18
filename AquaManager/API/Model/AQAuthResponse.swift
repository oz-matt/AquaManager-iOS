//
//  AQAuthResponse.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQAuthResponse: Mappable {
    var qresponse: String?
    var qdata: AQAuthResponseData?
    var aqsensParsed: [AQSensData]?
    var aqsens: String?
    
    init() {

    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.qresponse <- map["qresponse"]
        self.qdata <- map["qdata"]
        self.aqsens <- map["aqsens"]
        
        if self.aqsens != nil {
            self.aqsensParsed = Mapper<AQSensData>().mapArray(JSONString: self.aqsens!)
        }
    }
}


class AQAuthResponseData: Mappable {
    var aquakey: String?
    var phoneNumber: String?
    
    init() {

    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.aquakey <- map["aquakey"]
        self.phoneNumber <- map["phonenumber"]

    }
}

