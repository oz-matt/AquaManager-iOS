//
//  AQRemoveNotifRequest.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQRemoveNotifRequest: Mappable {
    var reqtype: String?
    var aquaname: String?
    var ntfid: String?
    var niid: String?
    
    init() {
        reqtype = "rmntfid"
        niid = "12341234123412341234"
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.reqtype <- map["reqtype"]
        self.aquaname <- map["aquaname"]
        self.ntfid <- map["ntfid"]
        self.niid <- map["iid"]
    }
}
