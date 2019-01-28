

//
//  File.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 21/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum APIRouter : URLRequestConvertible {
    
    static let baseURLString  = "http://devstree.in/projects/vsnap-new/web-api/"
    
    case clientLogin(email: String,password:String)
    case getClientEvents(clientID:String)
    case reserpassword(email:String)
    case getClientEventDetails(eventId:String,device_name:String,device_model:String,lat:String,long:String)
    
    // HTTP METHOD APPLY
    private var htttpMethod : HTTPMethod
    {
        switch self {
        case .clientLogin,
             .getClientEvents,
             .reserpassword,
             .getClientEventDetails :
            return .post
        }
    }
    
    // API ENDING PATH
    private var apiPath : String
    {
        switch self {
        case .clientLogin:
            return "client/login"
        case .getClientEvents:
            return "event/list"
        case .reserpassword:
            return "client/forgetpassword"
        case .getClientEventDetails :
            return "event/detail"
        }
    }
    
    // PARAMETERS APPLIED
    
    private var parameter : Dictionary<String,Any> {
        switch self {
        case .clientLogin(email: let email, password: let password):
            return["email":email,"password":password]
        case .getClientEvents(clientID: let clientId):
            return ["client_encrypt_id":clientId]
        case .reserpassword(email: let email):
            return ["email":email]
        case .getClientEventDetails(let eventId,let device_name,let device_model,let lat,let long) :
            return ["event_encrypt_id":eventId,
                    "device_name":device_name,
                    "device_model":device_model,
                    "event_lat":lat,
                    "event_long":long]
        }
    }
    //URL REQUEST
    public func asURLRequest() throws -> URLRequest {
        let parameters = self.parameter
        let url = try APIRouter.baseURLString.asURL()
        var request = URLRequest(url: url.appendingPathComponent(self.apiPath))
        request.httpMethod = self.htttpMethod.rawValue
        let boundary = generateBoundaryString()
        let contentType = "multipart/form-data; boundary=" + boundary
        request.setValue(contentType, forHTTPHeaderField: "content-Type")
        request.httpBody = createBody(withBoundary: boundary, parameters: parameters)
        return try request.asURLRequest()
    }
    
    public func generateBoundaryString() -> String {
        return "Boundary-" + NSUUID().uuidString
    }
    
    public func createBody(withBoundary boundary: String?, parameters: [String : Any]?) -> Data? {
        var httpBody = Data()
        
        // add params (all params are strings)
        
        for (key, Value) in parameters! {
            if let anEncoding = "--\(boundary ?? "")\r\n".data(using: String.Encoding.utf8) {
                httpBody.append(anEncoding)
            }
            if let anEncoding = "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8) {
                httpBody.append(anEncoding)
            }
            if let anEncoding = "\(Value)\r\n".data(using: String.Encoding.utf8) {
                httpBody.append(anEncoding)
            }
        }
        if let anEncoding = "--\(boundary ?? "")--\r\n".data(using: String.Encoding.utf8) {
            httpBody.append(anEncoding)
        }
        return httpBody
    }
}

