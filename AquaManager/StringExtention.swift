//
//  StringExtention.swift
//  AquaManager
//
//  Created by Anton on 2/1/17.
//  Copyright © 2017 Solidum. All rights reserved.
//

import Foundation
import Alamofire

extension String {
    
    var blank: Bool {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    
    var parseJSONString: Any? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data {
            // Will return an object or nil if JSON decoding fails
            do {
                let result = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
                return result
            }
            catch {
                return nil
            }
            
        } else {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined(separator: "")
    }
    
}

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
