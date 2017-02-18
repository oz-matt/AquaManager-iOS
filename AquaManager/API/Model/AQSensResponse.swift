//
//  AQSensResponse.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQSensResponse: Mappable {
    var qresponse: String?
    var qdata: [AQSensData]?
    var sensDataRaw: String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.qresponse <- map["qresponse"]
        self.qdata <- map["qdata"]
        if self.qdata != nil {
           self.sensDataRaw = self.qdata!.toJSONString(prettyPrint: false)!
        }
        
    }
}
