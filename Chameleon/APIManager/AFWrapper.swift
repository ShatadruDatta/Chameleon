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
    
    class func requestPOSTURL(_ strURL : String, params : [String : Any]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (String) -> Void){
        
        if Reachability.isConnectedToNetwork() {
//            Alamofire.request(strURL, method: .post, parameters: params, encoding:  URLEncoding.httpBody, headers: headers).responseJSON { (responseObject) -> Void in
//                //JSONEncoding.default
//                print(responseObject)
//                
//                if responseObject.result.isSuccess {
//                    let resJson = JSON(responseObject.result.value!)
//                    success(resJson, responseObject.data!)
//                }
//                if responseObject.result.isFailure {
//                    let error : Error = responseObject.result.error!
//                    failure(error)
//                }
//            }
            print(params?.getJsonString() ?? [:])
            let jsonData = try? JSONSerialization.data(withJSONObject: params ?? [:])
            let url = URL(string: strURL)! //PUT Your URL
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("\(apiKey)", forHTTPHeaderField: "x-api-key")
            request.setValue("\(Chameleon.token)", forHTTPHeaderField: "X-Token")
            // insert json data to the request
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    failure(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON) //Code after Successfull POST Request
                    let resJson = JSON(responseJSON)
                    success(resJson)
                }
            }

            task.resume()
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
