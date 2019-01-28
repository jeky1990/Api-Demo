//
//  APIManager.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 21/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class APIManager {
    
    static let errorDomain = "com.vsnap.error"
    
    var userEmail : String?
    var userPassword : String?
    
    public static let sharedInstance = APIManager()
    private init(){
        
    }
}

extension APIManager : APIProtocol {

    func performClientLogin(with email: String, password: String, completion: @escaping (URLRequest?, MainResponse?, NSError?) -> ()) {
        
        let request = Alamofire.request(APIRouter.clientLogin(email: email, password: password))
        startRequest(request) { (req, data, error) in
            if let data = data
            {
                do{
                    
                    let json = try JSON.init(data: data)
                    if json["status"] == true
                    {
                        let ClientData = try JSONDecoder().decode(MainResponse.self, from: data)
                        completion(req,ClientData,nil)
                    }
                    else
                    {
                        let err = NSError.init(domain: "ServerErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:json["message"].description])
                        completion(req,nil,err)
                    }
                    
                }catch{
                    
                    let err = NSError.init(domain: "CustomErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:"CustomerrorDoman"])
                    completion(req,nil,err)
                }
            }
            else
            {
                completion(req,nil,error)
            }
        }
    }
    
    func getClientEvents(clientID: String, completion: @escaping (URLRequest?,EventMainReponse?, NSError?) -> ()) {
      
        let request = Alamofire.request(APIRouter.getClientEvents(clientID: clientID))
        startRequest(request) { (req, data, error) in
            
            if let data = data {
                do {
                    let json = try JSON.init(data: data)
                    if json["status"].boolValue == true {
                        let eventList = try JSONDecoder().decode(EventMainReponse.self, from: data)
                        completion(req,eventList, nil)
                    } else {
                        let err = NSError.init(domain: "ServerErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:json["message"].description])
                        completion(req,nil, err)
                    }
                } catch let err {
                    let Err = NSError.init(domain: "CustomErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:err.localizedDescription])
                    completion(req,nil, Err)
                }
            } else {
                //                let err = error//NSError.init(domain: kCustomErrorDomain, code: kCustomErrorCode, userInfo: [NSLocalizedDescriptionKey:kSomethingWrong])
                completion(req,nil,error)
            }
        }
    }
    
    func resetPassword(clientEmail:String, completion: @escaping (URLRequest?, JSON, NSError?) -> ()) {
        
        let request = Alamofire.request(APIRouter.reserpassword(email: clientEmail))
        startRequest(request) { (req, data, error) in
            if let data = data {
                do {
                    let json = try JSON.init(data: data)
                    if json["status"].boolValue == true {
                        completion(req, json, nil)
                    } else {
                        let err = NSError.init(domain: "ServerErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:json["message"].description])
                        completion(req, JSON.null, err)
                    }
                } catch let e{
                    let err = NSError.init(domain: "CustomErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:e.localizedDescription])
                    completion(req, JSON.null, err)
                }
            } else {
                completion(req, JSON.null, error)
            }
        }
    }
    
    func getClientEventDetails(eventID: String, device_name: String, device_model: String, lat: String, long: String, completion: @escaping (ClientEventDetail?, NSError?) -> ()) {
        let request = Alamofire.request(APIRouter.getClientEventDetails(eventId: eventID, device_name: device_name, device_model: device_model, lat: lat, long: long))
        startRequest(request) { (req, data, error) in
            if let data = data
            {
                do{
                    let json = try JSON.init(data: data)
                     print(json)
                    if json["status"].boolValue == true
                    {
                        let ClientEventDetail1 = try JSONDecoder().decode(ClientEventDetail.self, from: data)
                        completion(ClientEventDetail1,nil)
                    }
                    else
                    {
                        let err = NSError.init(domain: "ServerErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:json["message"].description])
                        completion(nil, err)
                    }
                }catch let err {
                    let Err = NSError.init(domain: "CustomErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:err.localizedDescription])
                    completion(nil, Err)
                }
            }
            else
            {
                completion(nil,error)
            }
            
        }
    }
    
   
    func startRequest(_ dataRequest:DataRequest,completion:@escaping(URLRequest?,Data?,NSError?) -> ())
    {
        dataRequest.responseData { (responce) in
            if let error = responce.error
            {
                let err = NSError.init(domain: "ResponceErrordomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
                completion(responce.request,nil,err)
            }
            else
            {
                if let data = responce.data
                {
                    do{
                        let json = try JSON.init(data: data)
                        if json["status"].boolValue == true
                        {
                            completion(responce.request,data,nil)
                        }
                        else
                        {
                            let err = NSError.init(domain: "ServerErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:json["message"].description])
                            completion(responce.request,nil,err)
                        }
                        
                    }catch let jsonErr{
                        
                        print(jsonErr.localizedDescription)
                        let err = NSError.init(domain: "CustomErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:"SomethingWrong"])
                        completion(responce.request,nil,err)
                    }
                }
                else
                {
                    let err = NSError.init(domain: "CustomErrorDomain", code: 9855, userInfo: [NSLocalizedDescriptionKey:"SomethingWrong"])
                    completion(responce.request,nil,err)
                }
            }
        }
    }
}


