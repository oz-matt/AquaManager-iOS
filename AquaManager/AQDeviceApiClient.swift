//
//  AQDeviceApiClient.swift
//  AquaManager
//
//  Created by Anton on 2/3/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import ObjectMapper

class AQDevicesApiClient: AQApiClient {
    func registerDevice(aquaId: String, passcode: String, completion: @escaping (AQAuthResponse?, Bool) -> Void) {
        let request: AQAuthRequest = AQAuthRequest()
        request.pass = passcode
        request.id = aquaId
        POST("", body: request.toJSONString(prettyPrint: false)!, headers: nil) { (response, success) in
            let authResponse: AQAuthResponse? = Mapper<AQAuthResponse>().map(JSONObject: response.result.value)
            completion(authResponse, success)
        }
    }
    
    func updateQSensForDevice(device: AQDevice, completion: @escaping (AQSensResponse?, Bool) -> Void) {
        if device.aquaKey == nil || device.pass == nil {
            completion(nil, false)
            return
        }
        let request: AQAqsenRequest = AQAqsenRequest()
        request.pass = device.pass!
        request.aquakey = device.aquaKey
        POST("", body: request.toJSONString(prettyPrint: false)!, headers: nil) { (response, success) in
            let aResponse: AQSensResponse? = Mapper<AQSensResponse>().map(JSONObject: response.result.value)
            completion(aResponse, success)
        }
    }
}
