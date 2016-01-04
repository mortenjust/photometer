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
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var meterImage:MeterImage?
    var pin:MKPointAnnotation!
    let manager = CLLocationManager()
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidAppear(animated: Bool) {
         self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        pin = MKPointAnnotation()
        if let image = meterImage {
            showImageOnMap(image)
        } else {
            showCurrentLocationOnMap()
        }
        
    }
    
    
    func showCurrentLocationOnMap(){
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        
        // just in case
        NSTimer.after(1.second) { () -> Void in
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        moveCameraToLocation(newLocation)
    }
    
    func movePinToCoordinate(coordinate:CLLocationCoordinate2D){
        pin.coordinate = coordinate
    }
    
    
    func showImageOnMap(image:MeterImage){
        if let location = image.location {

            
            let altitude = formatDistance(location.altitude)
            let speed = formatSpeed(location.speed)
            let floor = location.floor?.level == nil ? "" : "\(location.floor?.level) floor"
            
            
            pin.title = formatTime(image.creationDate)
            pin.subtitle = "altitude \(altitude) \(speed) \(floor)"
            
            print(pin.subtitle!)
            movePinToCoordinate(location.coordinate)
            mapView.addAnnotation(pin)
            moveCameraToLocation(location)
            mapView.selectAnnotation(pin, animated: true)
        }
    }
    
    func moveCameraToLocation(loc:CLLocation){
        let cam = MKMapCamera(lookingAtCenterCoordinate: loc.coordinate, fromDistance: 500, pitch: 50, heading: 0)
    
        mapView.camera = cam
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
