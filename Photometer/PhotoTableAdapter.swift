//
//  PhotoTableAdapter.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource {
    var photoTable : UITableView!

    var allPhotos:[MeterImage] = [MeterImage]()

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (allPhotos.count * 2) - 1
        print("just returned \(count)")
        return count
    }
    
    func rowIsPhoto(rowNumber:Int) -> Bool {
        return rowNumber%2 == 0 ? true : false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if rowIsPhoto(indexPath.row) {
            
            let photo = photoTable.dequeueReusableCellWithIdentifier("photoCell")! as! PhotoCell
            let photoId = (indexPath.row+1)/2
            let currentPhoto = allPhotos[photoId]
            photo.meterImage = currentPhoto
            if let location = currentPhoto.location {
               photo.setAddressString(location)
            }
            photo.updateTimeTaken(currentPhoto.creationDate)
            photo.getImage()
            return photo
        } else {
            
            let interval = photoTable.dequeueReusableCellWithIdentifier("intervalCell")! as! IntervalCell
            
            let intervalTimes = getTimestampsForIntervalCell(indexPath.row)
            interval.updateElapsedTimeFromStartAndEndTimes(intervalTimes.start, end: intervalTimes.end)
            if let locations = getLocationsForIntervalCell(indexPath.row) {
                interval.updateLocationDistanceFromStartAndEndLocations(locations.start, end: locations.end)
                interval.updateAltitudeDifference(locations.start, end: locations.end)
            }
            
            return interval
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if rowIsPhoto(indexPath.row){
            return 130
        } else {
            return 138
        }
    }
    
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if rowIsPhoto(indexPath.row){
            let photoCell = cell as! PhotoCell
            photoCell.prepareToEnterViewport()
        }
    }
    
    
    func getLocationsForIntervalCell(cellIndex:Int) -> (start:CLLocation, end:CLLocation)? {
        let aboveIndex = ((cellIndex-1) + 1) / 2
        let belowIndex = ((cellIndex+1) + 1) / 2
        
        if let end = allPhotos[aboveIndex].location {
            if let start = allPhotos[belowIndex].location {
                return(start:start, end:end)
            }
        }
        
        return nil
    }
    
    func getTimestampsForIntervalCell(cellIndex:Int) -> (start:NSDate, end:NSDate){
        let aboveIndex = ((cellIndex-1) + 1) / 2
        let belowIndex = ((cellIndex+1) + 1) / 2

        let start = allPhotos[belowIndex].creationDate
        let end = allPhotos[aboveIndex].creationDate
        
        return(start:start, end:end)
     }
}
