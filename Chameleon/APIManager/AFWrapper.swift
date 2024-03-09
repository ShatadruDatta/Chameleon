//
//  AFWrapper.swift
//  Congress
//
//  Created by Shatadru Datta on 22/03/19.
//  Copyright © 2019 MSR. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
    
    class func requestGETURL(_ strURL: String, headers : [String : String]?, success: @escaping (JSON, Data) -> Void, failure: @escaping (Error) -> Void) {
        
        if Reachability.isConnectedToNetwork() {
            Alamofire.request(strURL, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson, responseObject.data!)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        } else {
            // No code now
        }
    }
    
    func jsonToNSData(json: AnyObject) -> NSData?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : Any]?, headers : [String : String]?, success:@escaping (JSON, Data) -> Void, failure:@escaping (Error) -> Void){
        
        if Reachability.isConnectedToNetwork() {
            Alamofire.request(strURL, method: .post, parameters: params, encoding:  URLEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
                //JSONEncoding.default
                print(responseObject)
                
                if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson, responseObject.data!)
                }
                if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
                }
            }
        } else {
            // No code now
        }
        
    }
}


extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
    
}
