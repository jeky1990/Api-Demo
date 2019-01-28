//
//  DownloadManager.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 25/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import Foundation
import Alamofire

class VsnapDownloadManager: NSObject {
    
    var alamoFireManager:SessionManager
    var i = 0
    var arrDownloadURL = [String]()
    var timer:Timer?
    var flag = true

    
    override init() {
        
        print(arrDownloadURL)
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.vsnap.download")
        configuration.timeoutIntervalForRequest = 200 // seconds
        alamoFireManager = Alamofire.SessionManager(configuration: configuration)
        
        
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityStatusDidChanged(_:)), name: NSNotification.Name.init(rawValue: kReachabilityStatusChanged), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init(rawValue: kReachabilityStatusChanged), object: nil)
    }

    
    func downloadEventData(with urlString:String, and type:Int) {
        if flag {
            var dirName = kEventDataDir
            if type == 1 {
                dirName = kClientDataDir
            }
            if urlString.range(of: "http") != nil, var url = URL(string: urlString) {
                let fileName = url.lastPathComponent
                url.deleteLastPathComponent()
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    let documentsURL = Util.documentDirectoryURL()
                    let dirURl = documentsURL.appendingPathComponent(dirName).appendingPathComponent(url.lastPathComponent)
                    let fileURL = dirURl.appendingPathComponent(fileName)
                    
                    return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
                }
                
                alamoFireManager.download(
                    url.appendingPathComponent(fileName).absoluteString,
                    method: .get,
                    parameters: nil,
                    encoding: JSONEncoding.default,
                    headers: nil,
                    to: destination).downloadProgress(closure: { (progress) in
                        
                        print(progress.fractionCompleted * 100)
                    }).response(completionHandler: { (response) in
                        print("Download URL : \(String(describing: response.destinationURL?.absoluteString))")
                        if response.error != nil {
                           // DPrint(data.localizedDescription)
                            NotificationCenter.default.post(name: Notification.Name(kDownloadCompled) , object: nil, userInfo: ["status":false, "error":kNoInternetConnection])
                        } else {
                            if self.i < self.arrDownloadURL.count - 1 {
                                self.i += 1
                                self.downloadEventData(with: self.arrDownloadURL[self.i], and: type)
                            } else {
                                DispatchQueue.main.async {
                                    NotificationCenter.default.post(name: Notification.Name(kDownloadCompled) , object: nil, userInfo: ["status":true])
                                    SKActivityIndicator.dismiss()
                                    
                                }
                            }
                        }
                    })
            } else {
                if i < arrDownloadURL.count - 1 {
                    i += 1
                    self.downloadEventData(with: self.arrDownloadURL[self.i], and: type)
                } else {
                    NotificationCenter.default.post(name: Notification.Name(kDownloadCompled) , object: nil, userInfo: ["status":true])
                }
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name(kDownloadCompled) , object: nil, userInfo: ["status":false, "error":kNoInternetConnection])
        }
    }
    
    fileprivate func cancelDownloadRequest() {
        alamoFireManager.session.getAllTasks { (tasks) in
            tasks.forEach({ (task) in
                task.cancel()
            })
        }
    }
    
    @objc func reachabilityStatusDidChanged(_ notification: Notification) {
        if flag == true {
            if let timer = timer {
                timer.invalidate()
                self.timer = nil
            }
        } else {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(showConnectionError), userInfo: nil, repeats: false)//init(timeInterval: 5.0, target: self, selector: #selector(showConnectionError), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func showConnectionError() {
        timer?.invalidate()
        timer = nil
        cancelDownloadRequest()
    }
}

