//
//  DetailViewController.swift
//  VisualStopwatch
//
//  Created by Morten Just Petersen on 12/28/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class DetailViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var meterImage:MeterImage!

    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let location = meterImage.location {
            let pin = MKPointAnnotation()
            
            let altitude = formatDistance(location.altitude)
            let speed = formatSpeed(location.speed)
            let floor = location.floor?.level == nil ? "" : "\(location.floor?.level) floor"
            
            
            pin.title = formatTime(meterImage.creationDate)
            pin.subtitle = "altitude \(altitude) \(speed) \(floor)"
            
            print(pin.subtitle!)
            
            pin.coordinate = location.coordinate
            mapView.addAnnotation(pin)
            let cam = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromDistance: 500, pitch: 50, heading: 0)
            mapView.camera = cam
            mapView.selectAnnotation(pin, animated: true)
            }
    }
    
    
    func formatDistance(d:CLLocationDistance) -> String {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .Default
        let distanceString = formatter.stringFromDistance(d)
        return d == 0 ? "" : distanceString
    }
    
    func formatSpeed(speed: CLLocationSpeed) -> String {
        return speed == 0 ? "" : String(format: "%.0f km/h", speed * 3.6)
    }
    
    func reverseGeocode(location:CLLocation) -> String {
        var locationLabel = ""
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) -> Void in
            if let p = placemarks {
                let address = p[0].name!
                locationLabel = address
            }
        }
        return locationLabel
    }
    
    func formatTime(date:NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .MediumStyle
        let dateString = formatter.stringFromDate(date)
        return "\(dateString)"
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
