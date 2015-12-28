//
//  DetailViewController.swift
//  VisualStopwatch
//
//  Created by Morten Just Petersen on 12/28/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import MapKit

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
        
        print("viedidload and setting coord: \(meterImage.location?.coordinate.latitude)")
        
        if let location = meterImage.location {
            let pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            mapView.addAnnotation(pin)
            let cam = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromDistance: 500, pitch: 50, heading: 0)
            mapView.camera = cam
            }
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
