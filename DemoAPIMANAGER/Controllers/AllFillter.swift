//
//  AllFillter.swift
//  DemoAPIMANAGER
//
//  Created by macbook on 24/12/18.
//  Copyright © 2018 macbook. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class AllFillter: UIViewController {
    
    //----Outlets
    @IBOutlet weak var collectionView : UICollectionView!
    
    //----Variable
    var clientSceneData : [Scene] = []
    var allImageandVideoInstring : [String] = []
    var clientSceneImageData : [UIImage] = []
    var timer = Timer()
    var i = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.TimerSet), userInfo: nil, repeats: true)
        for i in 1...4
        {
            print(clientSceneData[i].scene_background_image)
        }
        
        getSceneFromEventdetail()
    }
    
    @objc func TimerSet()
    {
        if i > 0
        {
            if i == 20
            {
                DispatchQueue.main.async {
                    SKActivityIndicator.show("Downloading EventData", userInteractionStatus: false)
                }
            }
            
            i -= 1
            print(i)
            
        }
        else
        {
            timer.invalidate()
            getSceneFromEventdetail()
            SKActivityIndicator.dismiss()
        }
    }
    
    func getSceneFromEventdetail()
    {
        
        for scene in clientSceneData {
            let logoURL = scene.scene_background_image
            
            if !logoURL.isEmpty, var url = URL(string: logoURL) {
                allImageandVideoInstring.append(scene.scene_background_image)
                let directory = Util.documentDirectoryURL()
                let fileName = url.lastPathComponent
                url.deleteLastPathComponent()
                let imgURL = directory.appendingPathComponent(kEventDataDir).appendingPathComponent(url.lastPathComponent).appendingPathComponent(fileName)
                print(imgURL.path)
                if let image = UIImage(contentsOfFile: imgURL.path)
                {
                    clientSceneImageData.append(image)
                }
                
            } else if !scene.scene_background_video.isEmpty, var url = URL(string: scene.scene_background_video) {
                allImageandVideoInstring.append(scene.scene_background_video)
                let directory = Util.documentDirectoryURL()
                let fileName = url.lastPathComponent
                url.deleteLastPathComponent()
                let imgURL = directory.appendingPathComponent(kEventDataDir).appendingPathComponent(url.lastPathComponent).appendingPathComponent(fileName)
                print(imgURL.path)
                if let image = Util.generateThumb(from: imgURL) {
                    clientSceneImageData.append(image)
                }
            }
        }
        
        collectionView.reloadData()
    }

    
    @IBAction func back (_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AllFillter : UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clientSceneImageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! filterCell
        
        cell.filterImageView.image = clientSceneImageData[indexPath.row]
        
        let a = allImageandVideoInstring[indexPath.row]
        let last4 = a.suffix(4)
        print(last4)
        if last4 == ".jpg"
        {
            cell.label.text = "Image"
        }
        else
        {
            cell.label.text = "Video"
        }
        
        
        return cell
    }
}

extension AllFillter:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let CollWidth = collectionView.bounds.width
        return CGSize(width: CollWidth/2-5, height: CollWidth/2-5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

public enum ImageFormat {
    case PNG
    case JPEG(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String {
        var imageData: Data
        switch format {
        case .PNG: imageData = self.pngData()!
        case .JPEG(let compression): imageData =  self.jpegData(compressionQuality: compression)!
        }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}

class filterCell : UICollectionViewCell
{
    @IBOutlet var filterImageView : UIImageView!
    @IBOutlet var  label : UILabel!
}
