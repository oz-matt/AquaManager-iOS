//
//  AQNotificationApiClient.swift
//  AquaManager
//
//  Created by Anton on 2/11/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQNotificationApiClient: AQApiClient {
    
    func removeNotificationById(notId: String, deviceName: String, completion: @escaping (AQSimpleResponse?, Bool) -> Void) {
        let request = AQRemoveNotifRequest()
        request.aquaname = deviceName
        request.ntfid = notId
        POST("", body: request.toJSONString(prettyPrint: false)!, headers: nil) { (response, success) in
            let aResponse: AQSimpleResponse? = Mapper<AQSimpleResponse>().map(JSONObject: response.result.value)
            completion(aResponse, success)
        }
    }
    
    func postNotification(notification: AQBaseNotificationRequest, completion: @escaping (AQSimpleResponse?, Bool) -> Void) {
        POST("", body: notification.toJSONString(prettyPrint: false)!, headers: nil) { (response, success) in
            let aResponse: AQSimpleResponse? = Mapper<AQSimpleResponse>().map(JSONObject: response.result.value)
            completion(aResponse, success)
        }
    }
    
}
