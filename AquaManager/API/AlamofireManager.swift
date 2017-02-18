//
//  AlamofireManager.swift
//  AquaManager
//
//  Created by Anton on 1/31/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import Alamofire

@objc class AlamofireManger: NSObject {
    static let sharedInstance = AlamofireManger()
    var alamofireManager: Alamofire.SessionManager = Alamofire.SessionManager()
    
    func reinitManager () {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 30.0
        alamofireManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    func Get(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire GET: \(url)")
        alamofireManager.request(url, method: .get, parameters: params, headers: headers).responseJSON { (response) in
            completion(response)
        }
    }
    
    func PATCH(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire PATCH: \(url)")
        alamofireManager.request(url, method: .patch, parameters: params, headers: headers).responseJSON { (response) in
            completion(response)
        }
    }
    
    func Post(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire POST: \(url)")
        alamofireManager.request(url, method: .post, parameters: params, headers: headers).responseJSON { (response) in
            completion(response)
        }
    }
    
    func Delete(_ url: String, params: [String: AnyObject]?, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire DELETE: \(url)")
        alamofireManager.request(url, method: .delete, parameters: params, headers: headers).responseJSON { (response) in
            completion(response)
        }
    }
    
    func Post(_ url: String, body: String, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire POST: \(url)\nBODY: \(body)")

        alamofireManager.request(url, method: .post, parameters: nil, encoding: body, headers: headers).responseJSON { (response) in
            print("Alamofire POST BODY: \(url)")
            completion(response)
        }
    }
    
    func Patch(_ url: String, body: String, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire PATCH: \(url)\nBODY: \(body)")
        alamofireManager.request(url, method: .patch, parameters: nil, encoding: body, headers: headers).responseJSON { (response) in
            print("Alamofire POST BODY: \(url)")
            completion(response)
        }
    }
    
    func Put(_ url: String, body: String, headers: [String: String]?, completion: @escaping (DataResponse<Any>) -> Void) {
        print("Alamofire PUT: \(url)\nBODY: \(body)")
        alamofireManager.request(url, method: .put, parameters: nil, encoding: body, headers: headers).responseJSON { (response) in
            print("Alamofire POST BODY: \(url)")
            completion(response)
        }
    }
    
    
}
