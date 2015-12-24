//
//  PhotoFetcher.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/20/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import Photos
import UIKit
import AssetsLibrary

class PhotoFetcher: NSObject {
    var allPhotos = [MeterImage]()

    func getAll(completion:([MeterImage])->Void) {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                switch status {
                case .Authorized:
                    self.getPhotos({ (photos) -> Void in
                        completion(photos)
                    })
                default:
                    self.noAccess()
                }
            })
        }
        
    }
    
    func noPhotos(){
        print("No photos in library.")
    }
    
    func noAccess(){
        print("No access, sorry.")
    }
    
    func handlePhotos(results:PHFetchResult, completion:([MeterImage])->Void) {
        var collectedPhotos = [MeterImage]()
        
        results.enumerateObjectsUsingBlock { (object, count, stop) -> Void in
            if object is PHAsset {
                let asset = object as! PHAsset
                let photo = MeterImage()
                photo.creationDate = asset.creationDate
                photo.asset = asset
                
                if let l = asset.location {
                    photo.location = l
                }
                
                collectedPhotos.append(photo)
            }
            
            if (count == results.count-1) {
                completion(collectedPhotos)
            }
        }
    }
    
    func getPhotos(completion:([MeterImage])->Void){
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let assetResults = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        if (assetResults.count > 1){
            handlePhotos(assetResults, completion: { (photos) -> Void in
                completion(photos)
            })
        } else {
            noPhotos()
        }
        
    }

}
