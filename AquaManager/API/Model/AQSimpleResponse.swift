//
//  AQSimpleResponse.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQSimpleResponse: Mappable {
    var qresponse: String?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.qresponse <- map["qresponse"]
    }
    
    func getStringResponse() -> String {
        if qresponse != nil {
            return qresponse!
        }
        else {
            return ""
        }
    }
}
