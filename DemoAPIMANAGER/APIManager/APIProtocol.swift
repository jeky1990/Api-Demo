//
//  APIProtocol.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 21/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol APIProtocol {
    
    func performClientLogin(with email:String,password:String,completion: @escaping (_ request:URLRequest?,
        _ result:MainResponse?,_ error: NSError?) -> ())
    func getClientEvents(clientID: String, completion: @escaping (_ request:URLRequest?,EventMainReponse?, NSError?) -> ())
    func getClientEventDetails(eventID: String,device_name: String,device_model: String,lat: String,long: String, completion: @escaping (ClientEventDetail?, NSError?) -> ())
    
}


