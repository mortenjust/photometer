//
//  PhotoTableAdapter.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import CoreLocation

protocol PhotoTableAdapterDelegate {
    func PhotoTableWantsFetchUpdate()
}

class PhotoTableAdapter: NSObject, UITableViewDelegate, UITableViewDataSource, PhotoCellDelegate {
    var photoTable : UITableView!
    var allPhotos:[MeterImage] = [MeterImage]()
    var adapterDelegate : PhotoTableAdapterDelegate?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = (allPhotos.count * 2) - 1 + 1 // +1 is for the top photo which is the live one
        return count
    }
    
    func rowIsPhoto(rowNumber:Int) -> Bool {
        return rowNumber%2 == 0 ? true : false
    }
    
    func getPhotoCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {
        let photo = photoTable.dequeueReusableCellWithIdentifier("photoCell")! as! PhotoCell
        photo.resetAllLabels()
        let photoId = (indexPath.row+1)/2 - 1
        let currentPhoto = allPhotos[photoId]
        photo.meterImage = currentPhoto
        if let location = currentPhoto.location {
            photo.setAddressString(location)
        }
        photo.updateTimeTaken(currentPhoto.creationDate)
        photo.getImage()
        return photo
    }
    
    func photoCellWantsTableUpdate() {
        adapterDelegate?.PhotoTableWantsFetchUpdate()
    }
    
    func getLivePhotoCell()->UITableViewCell{
        let photo = photoTable.dequeueReusableCellWithIdentifier("photoCell")! as! PhotoCell
        photo.delegate = self
        photo.showCameraButton()
        photo.resetAllLabels()
        photo.updateTimeTaken(NSDate())
        return photo
    }
    
    func getIntervalCellForIndexPath(indexPath:NSIndexPath) -> UITableViewCell {
        let interval = photoTable.dequeueReusableCellWithIdentifier("intervalCell")! as! IntervalCell
        interval.resetAllLabels()
        let intervalTimes = getTimestampsForIntervalCell(indexPath.row)
        interval.updateElapsedTimeFromStartAndEndTimes(intervalTimes.start, end: intervalTimes.end)
        if let locations = getLocationsForIntervalCell(indexPath.row) {
            interval.updateLocationDistanceFromStartAndEndLocations(locations.start, end: locations.end)
            interval.updateAltitudeDifference(locations.start, end: locations.end)
        }
        return interval
    }
    
    func getLiveIntervalCell()->UITableViewCell{
        let interval = photoTable.dequeueReusableCellWithIdentifier("intervalCell")! as! IntervalCell
        
        interval.resetAllLabels()
        let mostRecentPhotoTimestamp = getMostRecentTimestamp()
        interval.beginTimerFrom(mostRecentPhotoTimestamp)        
        return interval
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
             return getLivePhotoCell()
        }
        if indexPath.row == 1 {
            return getLiveIntervalCell()
        }
        
        if rowIsPhoto(indexPath.row) {
            return getPhotoCellForIndexPath(indexPath)
        } else {
            return getIntervalCellForIndexPath(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if rowIsPhoto(indexPath.row){
            return 130
        } else {
            return 138
        }
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !rowIsPhoto(indexPath.row){
            let intervalCell = cell as! IntervalCell
            intervalCell.stopTimer()
        } else {
        
            let photoCell = cell as! PhotoCell
            photoCell.leaveViewPort()
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        if rowIsPhoto(indexPath.row){
//            let photoCell = cell as! PhotoCell
//            photoCell.prepareToEnterViewport()
//        }
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
    
    func getMostRecentTimestamp() -> NSDate {
        let mostRecentIndex = 0
        return allPhotos[mostRecentIndex].creationDate
    }
    
    func getTimestampsForIntervalCell(cellIndex:Int) -> (start:NSDate, end:NSDate){
        let aboveIndex = ((cellIndex-1) + 1) / 2
        let belowIndex = ((cellIndex+1) + 1) / 2

        let start = allPhotos[belowIndex].creationDate
        let end = allPhotos[aboveIndex].creationDate
        
        return(start:start, end:end)
     }
}
