//
//  MainPage.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 22/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit
import CoreLocation


class EventList: UIViewController {

    //---- outlets
    @IBOutlet weak var EventTableList : UITableView!
    
    //---- Varable Declaration
    var ClientEventsData : [ClientEvents] = []
    let locationManager = CLLocationManager()
    var CurrentLocation = CLLocationCoordinate2D()
    var selecedIndex : Int?
    var event_encrypt_id : String = ""
    var clientAllScene : [Scene] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        NotificationCenter.default.addObserver(self, selector: #selector(self.CheckLocationServiceEnable(notification:)), name:UIApplication.willEnterForegroundNotification , object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(eventDataDidDownload(_:)), name: Notification.Name(kDownloadCompled), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(kDownloadCompled), object: nil)
    }
    
    @objc func eventDataDidDownload(_ notification:Notification)
    {
        let nav : AllFillter = self.storyboard?.instantiateViewController(withIdentifier: "AllFillter") as! AllFillter
        nav.clientSceneData = clientAllScene
        self.navigationController?.pushViewController(nav, animated: true)
    }
    
    func setUpUI()
    {
        EventTableList.backgroundColor = UIColor.white
    }

    func clientLogout()
    {
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        UserDefaults.standard.set(nil, forKey: "clientId")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Logoutbutton(_ sender : UIButton)
    {
        clientLogout()
        print("Successfully LogOut")
    }
    
    func getClientEventDetail(event_encrypt_id : String)
    {
        APIManager.sharedInstance.getClientEventDetails(eventID: event_encrypt_id,device_name: UIDevice.current.name,device_model: UIDevice.modelName,lat: String(23.033863),long: String(72.585022)) { (clienrEventdetail, error) in
            
            if let error = error {
                print(error.localizedDescription)
              
            } else {
                if let detail = clienrEventdetail, detail.data.isEmpty == false {
                    
                    if event_encrypt_id == detail.data[0].event_encrypt_id {
                        print("id matched")
                        self.clientAllScene = detail.data[0].scenes_data
                        self.prepareDownloadQueue(from: detail.data[0])
                        
                    }else {
                        print("id not matched")
                    }
                }
            }
            
        }
    }
    
    func prepareDownloadQueue(from event:EventDetails) {
        let filemanager = FileManager.default
        let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dirURl = documentsURL.appendingPathComponent(kEventDataDir)
        
        if Util.directoryExistsAtPath(dirURl.path) {
            do {
                try filemanager.removeItem(at: dirURl)
            } catch let error {
                print(error)
            }
        }
        
        var arrDownloadURL = [String]()
        arrDownloadURL.append(event.event_start_screen_background_image)
        arrDownloadURL.append(event.event_logo_image)
        arrDownloadURL.append(event.event_chroma_key_image)
        
        for sceneData in event.scenes_data {
            if !sceneData.scene_background_image.isEmpty {
                arrDownloadURL.append(sceneData.scene_background_image)
            }
            
            if !sceneData.scene_background_video.isEmpty {
                arrDownloadURL.append(sceneData.scene_background_video)
            }
            
            if !sceneData.scene_overlay_image.isEmpty {
                arrDownloadURL.append(sceneData.scene_overlay_image)
            }
            
            if !sceneData.scene_overlay_video.isEmpty {
                arrDownloadURL.append(sceneData.scene_overlay_video)
            }
        }
        
        let downloadManager = VsnapDownloadManager()
        downloadManager.arrDownloadURL = arrDownloadURL
        SKActivityIndicator.show("Downloading event Data...", userInteractionStatus: false)
        downloadManager.downloadEventData(with: arrDownloadURL[0], and: 0)
        
    }
    
    @IBAction func EventButton (_ sender: UIButton)
    {
        if event_encrypt_id == ""
        {
            let alert = UIAlertController(title: "Alert!!", message: "Please select an Event", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            getClientEventDetail(event_encrypt_id: event_encrypt_id)
        }
    }
}


extension EventList : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ClientEventsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EventCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventCell
        
        let SingleClientEventData = ClientEventsData[indexPath.row]
        
        cell.eventTitle.text = SingleClientEventData.event_title
        cell.videoAssetsCount.text = SingleClientEventData.total_assets_count
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let EventDetail = ClientEventsData[indexPath.row]
        selecedIndex = indexPath.row
        event_encrypt_id = EventDetail.event_encrypt_id
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

class EventCell: UITableViewCell {
    
    //---- Outlets
    @IBOutlet var eventTitle : UILabel!
    @IBOutlet var videoAssetsCount : UILabel!
    
}
extension EventList : CLLocationManagerDelegate {

    @objc func CheckLocationServiceEnable(notification: NSNotification) {
        AuthorisationLocation()
    }
    
    func  AuthorisationLocation() {
    
        if isLocationServiceEnabled() == true {
            self.locationManager.requestAlwaysAuthorization()
            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        } else {
            //You could show an alert like this.
            let alertController = UIAlertController(title: "Location Services Disabled", message: "Please enable location services for this     app.", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                NSLog("OK Pressed")
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            alertController.addAction(OKAction)
            alertController.addAction(cancelAction)
            OperationQueue.main.addOperation {
                self.present(alertController, animated: true,
                             completion:nil)
            }
        }
    }
    
    func isLocationServiceEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Something wrong with Location services")
                return false
            }
        } else {
            print("Location services are not enabled")
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        CurrentLocation = locValue
        locationManager.stopUpdatingLocation()
    }

}
