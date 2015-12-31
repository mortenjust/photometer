//
//  MeterImageAnnotation.swift
//  VisualStopwatch
//
//  Created by Morten Just Petersen on 12/29/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import MapKit

class MeterImageAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    
}
