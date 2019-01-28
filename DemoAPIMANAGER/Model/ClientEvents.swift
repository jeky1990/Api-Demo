//
//  ClientEvents.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 21/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation
import SwiftyJSON

class EventMainReponse : Codable
{
    var status : Bool
    var message : String
    var data : [ClientEvents]
}

class ClientEvents : Codable
{
    var client_encrypt_id : String
    var event_encrypt_id : String
    var event_title : String
    var total_assets_count : String
}
