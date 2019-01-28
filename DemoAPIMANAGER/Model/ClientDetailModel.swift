//
//  ClientDetailModel.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 21/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation

class MainResponse : Codable
{
    var status : Bool
    var message : String
    var data : ClientData
}

class ClientData : Codable
{
    var client_entity_id : String
    var client_encrypt_id : String
    var client_name : String
    var client_email : String
    var client_phone : String
    var client_logo : String
    var client_hide_admin_branding : String
    var client_terms_and_privacy_policy : String
    var client_top_banner : String
    var client_bottom_banner : String
    var client_manage_events: String
    var client_change_brand_logo : String
    var client_change_brand_name : String
    var client_status : String
}

