//
//  constant.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 25/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation
import UIKit

let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
let APP_DELEGATE = UIApplication.shared.delegate as! AppDelegate

let kAlbumName                  = "vsnap"
let kEventDataDir               = "eventData"
let kClientDataDir              = "clientData"
let kDownloadCompled            = "eventDataDownloaded"
let kReachabilityStatusChanged  = "reachabilityStatusChanged"
let kNoInternetConnection       = "Internet not available, Cross check your internet connectivity and try again"
let kSomethingWrong             = "Something went wrong. Please try again later."
let kChromaColor                = "chromaColor"
let kChromaIntencity            = "chromaIntencity"
let kChromaSmoothing            = "chromaSmoothing"
