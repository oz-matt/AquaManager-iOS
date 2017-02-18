//
//  AQApiClient.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import Alamofire

class AQApiClient {
    
    let API_URL = "http://198.61.169.55:8081"
    
    static let RESPONSE_CODE_SUCCESS = 200
    static let RESPONSE_CODE_SUCCESS_CREATED = 201
    static let RESPONSE_CODE_SUCCESS_BAD_REQUEST = 400
    static let RESPONSE_CODE_SUCCESS_UNAUTHORISED = 401
    static let RESPONSE_CODE_SUCCESS_FORBIDDEN = 403
    static let RESPONSE_CODE_INTERNAL_SERVER_ERROR = 500
    static let DEFAULT_PAGE_SIZE = 20
    
    let AQApiErrorNotification = "AQApiErrorNotification"
    
    let alamofireManager: AlamofireManger = AlamofireManger.sharedInstance
    
    func getApiUrl(_ url: String) -> String {
        return API_URL
    }
    
    func GET(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>, Bool) -> Void) {
        let fullurl: String = getApiUrl(url)
        
        var newHeaders: [String: String]? = headers
        if sign {
            newHeaders = signHeader(headers)
        }
        
        alamofireManager.Get(fullurl, params: params, headers: newHeaders) { (response) in
            //check response
            print(response)
            if self.processResponseIsOk(response) {
                completion(response, true)
            }
            else {
                print("Error: \(response.result.error)")
                if response.result.error != nil && !(response.description.contains("lost") || response.description.contains("server")) {
                    self.showErrorMessage(response.result.error!.localizedDescription)
                }
                
                completion(response, false)
            }
        }
    }

    func signHeader(_ headers: [String: String]?) -> [String: String]? {
        var newHeaders: [String: String]? = headers
        if newHeaders == nil {
            newHeaders = ["Content-Type": "application/json"]
        }
        else {
            newHeaders!["Content-Type"] = "application/json"
        }
        return newHeaders!
    }
    
    func POST(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>, Bool) -> Void) {
        let fullurl: String = getApiUrl(url)
        
        var newHeaders: [String: String]? = headers
        if sign {
            newHeaders = signHeader(headers)
        }
        
        alamofireManager.Post(fullurl, params: params, headers: newHeaders) { (response) in
            //check response
            
            print(response)
            if self.processResponseIsOk(response) {
                completion(response, true)
            }
            else {
                print("Error: \(response.result.error)")
                if response.result.error != nil && !(response.description.contains("lost") || response.description.contains("server")) {
                    self.showErrorMessage(response.result.error!.localizedDescription)
                }
                completion(response, false)
            }
        }
    }
    
    func DELETE(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>, Bool) -> Void) {
        let fullurl: String = getApiUrl(url)
        
        var newHeaders: [String: String]? = headers
        if sign {
            newHeaders = signHeader(headers)
        }
        
        alamofireManager.Delete(fullurl, params: params, headers: newHeaders) { (response) in
            //check response
            
            print(response)
            if self.processResponseIsOk(response) {
                completion(response, true)
            }
            else {
                print("Error: \(response.result.error)")
                if response.result.error != nil && !(response.description.contains("lost") || response.description.contains("server")) {
                    self.showErrorMessage(response.result.error!.localizedDescription)
                }
                completion(response, false)
            }
        }
    }
    
    func POST(_ url: String, body: String, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>, Bool) -> Void) {
        let fullurl: String = getApiUrl(url)
        
        var newHeaders: [String: String]? = headers
        if sign {
            newHeaders = signHeader(headers)
        }
        
        alamofireManager.Post(fullurl, body: body, headers: newHeaders) { (response) in
            //check response
            print(response)
            if self.processResponseIsOk(response) {
                completion(response, true)
            }
            else {
                print("Error: \(response.result.error)")
                if response.result.error != nil && !(response.description.contains("lost") || response.description.contains("server")){
                    self.showErrorMessage(response.result.error!.localizedDescription)
                }
                completion(response, false)
            }
        }
    }
    
    func POST_BODY(_ url: String, body: String, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>) -> Void) {
        let fullURL: String = getApiUrl(url)
        
        let newHeaders: [String: String]? = signHeader(headers)
        
        alamofireManager.Post(fullURL, body: body, headers: newHeaders) { (response) in
            print(response)
            if self.processResponseIsOk(response) {
                completion(response)
            } else {
                print("Error: \(response.result.error)")
                completion(response) // is it OK?
            }
        }
    }
    
    func PUT(_ url: String, body: String, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>, Bool) -> Void) {
        let fullurl: String = getApiUrl(url)
        
        var newHeaders: [String: String]? = headers
        if sign {
            newHeaders = signHeader(headers)
        }
        
        alamofireManager.Put(fullurl, body: body, headers: newHeaders) { (response) in
            //check response
            
            print(response)
            if self.processResponseIsOk(response) {
                completion(response, true)
            }
            else {
                print("Error: \(response.result.error)")
                if response.result.error != nil && !(response.description.contains("lost") || response.description.contains("server")) {
                    self.showErrorMessage(response.result.error!.localizedDescription)
                }
                completion(response, false)
            }
        }
    }
    
    func PATCH(_ url: String, body: String, headers: [String: String]?, sign: Bool = true, completion: @escaping (DataResponse<Any>, Bool) -> Void) {
        let fullurl: String = getApiUrl(url)
        
        var newHeaders: [String: String]? = headers
        if sign {
            newHeaders = signHeader(headers)
        }
        
        alamofireManager.Patch(fullurl, body: body, headers: newHeaders) { (response) in
            //check response
            
            print(response)
            if self.processResponseIsOk(response) {
                completion(response, true)
            }
            else {
                print("Error: \(response.result.error)")
                if response.result.error != nil && !(response.description.contains("lost") || response.description.contains("server")) {
                    self.showErrorMessage(response.result.error!.localizedDescription)
                }
                completion(response, false)
            }
        }
    }
    
    func processResponseIsOk(_ response: DataResponse<Any>) -> Bool {
        let status: Int?  = response.response?.statusCode
        
        if status == nil {
            if response.description.contains("lost") || response.description.contains("server") || response.description.contains("offline") || response.description.contains("Internet") {
                //connectionLostResponse()
                return false
            }
            return true
        }
        
        switch status! {
        case 0: return false
        //V2 TODO operation timeout
        case AQApiClient.RESPONSE_CODE_SUCCESS:
            return true
        case AQApiClient.RESPONSE_CODE_SUCCESS_CREATED:
            return true
        case AQApiClient.RESPONSE_CODE_SUCCESS_FORBIDDEN:
            return false
        case AQApiClient.RESPONSE_CODE_SUCCESS_BAD_REQUEST:
            return false
        case AQApiClient.RESPONSE_CODE_SUCCESS_UNAUTHORISED:
            do {
                let dataDictionary = try JSONSerialization.jsonObject(with: response.data! as Data, options: .allowFragments) as? [String:AnyObject]
                if dataDictionary?["error"] as! String == "invalid_grant" {
                    return false
                } else {
                }
            } catch {
            }
            return false
        case AQApiClient.RESPONSE_CODE_INTERNAL_SERVER_ERROR:
            return false
        default:
            return false
        }
    }
    
    func showErrorMessage(_ error: String) {
        if error.contains("JSON") {
            return
        }
        
        if !error.contains("input data was nil") && !error.contains("Internet") {
            let notification: Notification = Notification(name: Notification.Name(rawValue: AQApiErrorNotification), object: error)
            NotificationCenter.default.post(notification)
        }
    }
    
    func connectionLostResponse() {
        let notification: Notification = Notification(name: Notification.Name(rawValue: "GCConnectionError"), object: nil)
        NotificationCenter.default.post(notification)
    }
    
    func encodeQueryString(_ string: String) -> String {
        let chars: NSMutableCharacterSet = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        chars.removeCharacters(in: "!*'\"();:@&=+$,/?%#[]% ")
        let newString = string.addingPercentEncoding(withAllowedCharacters: chars as CharacterSet)!
        return newString
    }
}
