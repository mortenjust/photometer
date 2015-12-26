//
//  intervalCell.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class IntervalCell: UITableViewCell {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var millisecondsLabel: UILabel!
    @IBOutlet weak var floorsLabel: UILabel!
    @IBOutlet weak var floorStick: UIView!
    var timer : NSTimer?
    
    var allLabels:[UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        allLabels = [distance, daysLabel, hoursLabel, minutesLabel, secondsLabel, floorsLabel, millisecondsLabel]
       C.setFormattingForLabels(allLabels)
        
        fadeOutLabels([millisecondsLabel, secondsLabel, minutesLabel, hoursLabel, daysLabel])
    }
    
    func fadeOutLabels(views:[UIView]){
        for view in views {
            view.alpha = 0
        }
    }
    
    func resetAllLabels(){
        for l in allLabels {
            l.text = ""
        }
    }
    
    func updateLocationDistanceFromStartAndEndLocations(start:CLLocation, end:CLLocation){
        self.distance.text = getLocationDistanceString(start, end: end)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func beginTimerFrom(mostRecentPhoto:NSDate){
        timer = NSTimer.every(0.08.seconds) { () -> Void in
            self.updateElapsedTimeFromStartAndEndTimes(mostRecentPhoto, end: NSDate())
            
        }
        timer?.fire()
    }
    
    func stopTimer(){
        timer?.invalidate()
    }
    
    func updateAltitudeDifference(start:CLLocation, end:CLLocation) {
        
        let diff = start.altitude.distanceTo(end.altitude)
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .Abbreviated

        let floors = round(diff / 3) // 3m ceiling
        var floorString = ""
        
        if floors > 0 {
            floorsLabel.hidden = false
            floorStick.hidden = false
            floorString = ", \(Int(abs(floors))) floors"
            floorsLabel.text = floorString
        } else {
            floorsLabel.hidden = true
            floorStick.hidden = true
        }
    }
    
    func getLocationDistanceString(start:CLLocation, end:CLLocation) -> String {
        let distance = start.distanceFromLocation(end)
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .Abbreviated
        let distanceString = formatter.stringFromDistance(distance)
        return distanceString
    }
    
    func fadeInIfNeeded(views:[UIView]){
        if views.first?.alpha == 1 { return }
        var i:Double = 0
        let stagger:Double = 100
        for view in views {
            UIView.animateWithDuration(0.5,
                delay: i++ * (stagger/1000),
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: { () -> Void in
                    view.alpha = 1
                },
                completion: nil)
        }
    }
    
    
    func updateElapsedTimeFromStartAndEndTimes(start:NSDate, end:NSDate) {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Hour, .Minute, .Second, .Nanosecond],
            fromDate: start,
            toDate: end,
            options: [])
        
        setTimeLabel(daysLabel, value: components.day, unit: "day")
        setTimeLabel(hoursLabel, value: components.hour, unit: "hour")
        setTimeLabel(minutesLabel, value: components.minute, unit: "minute")
        setTimeLabel(secondsLabel, value: components.second, unit: "second")
        
        let ms = Int(components.nanosecond/1000000)
        setTimeLabel(millisecondsLabel, value: ms, unit: "ms")
        
        
        fadeInIfNeeded([millisecondsLabel, secondsLabel, minutesLabel, hoursLabel, daysLabel])
    }
    
    
    func setTimeLabel(label:UILabel, value:Int, unit:String){
        var pluralS = ""
        
        switch value {
        case 0:
            if unit == "second" { break }
            label.hidden = true
            return
        case 1:
            break
        default:
            if unit != "ms" {
                pluralS = "s"
                }
            break
        }
        label.hidden = false
        label.text = "\(value) \(unit)\(pluralS)"
    }
    
}
