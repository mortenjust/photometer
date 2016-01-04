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


class IntervalCell : UITableViewCell {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var millisecondsLabel: UILabel!
    @IBOutlet weak var floorsLabel: UILabel!
    @IBOutlet weak var midStick: UIView!
    var topLabel: UILabel! // the colored one
    
    var timer : NSTimer?
    
    var allLabels:[UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        allLabels = [distance, daysLabel, hoursLabel, minutesLabel, secondsLabel, floorsLabel, millisecondsLabel]
    }
    
    func prepareForViewport(){

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
        timer = nil
    }
    
    func updateAltitudeDifference(start:CLLocation, end:CLLocation) {
        let diff = start.altitude.distanceTo(end.altitude)
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .Abbreviated

        let floors = round(diff / 3) // 3m ceiling
        var floorString = ""
        
        if floors > 1 {
            floorsLabel.hidden = false
            floorString = "\(Int(abs(floors))) floors"
            floorsLabel.text = floorString
        } else {
            floorsLabel.hidden = true
        }
    }
    
    func getLocationDistanceString(start:CLLocation, end:CLLocation) -> String {
        let distance = start.distanceFromLocation(end)
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .Abbreviated
        let distanceString = formatter.stringFromDistance(distance)
        return distanceString
    }
    
    
    func updateElapsedTimeFromStartAndEndTimes(start:NSDate, end:NSDate) {
        C.setFormattingForLabels(allLabels)
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
        setTimeLabel(millisecondsLabel, value: ms, unit: "millisecond")

        
        let timeLabels = [millisecondsLabel, secondsLabel, minutesLabel, hoursLabel, daysLabel]
        topLabel = millisecondsLabel
        
        
        for label in timeLabels {
            if label.hidden == false {
                topLabel = label
            }
        }
    }
    
    func getHSBA(color:UIColor) -> (hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat) {
        var hue:CGFloat = 0.0
        var sat:CGFloat = 0.0
        var bri:CGFloat = 0.0
        var alpha:CGFloat = 0.0
        color.getHue(&hue, saturation: &sat, brightness: &bri, alpha: &alpha)
        return (hue:hue, saturation:sat, brightness:bri, alpha:alpha)
    }

    
    func setTopLabelColorFromBackgroundColor(b: UIColor){
        let hsba = getHSBA(b)

        let hue = hsba.hue + 0.1 % 1.0
        let saturation = hsba.saturation - 0.5
        let brightness:CGFloat = 0.8
        let labelColor = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
        
        topLabel.textColor = labelColor
        
        let mutedVersion = UIColor(hue: hue, saturation: saturation, brightness: 0.3, alpha: 1)
        midStick.backgroundColor = mutedVersion
    }
    
    func setTimeLabel(label:UILabel, value:Int, unit:String){
        var pluralS = ""
        
        switch value {
        case 0:
            pluralS = "s"
//            if unit == "second" {
//                pluralS = "s"
//                break }
            label.hidden = true
            return
        case 1:
            break
        default:
            pluralS = "s"
            break
        }
        label.hidden = false
        label.text = "\(value) \(unit)\(pluralS)"
    }
    
}


