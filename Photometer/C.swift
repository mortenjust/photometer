//
//  C.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/23/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit

class C: NSObject {
//    static var labelColor = UIColor.lightGrayColor()
    
//    static var imageBorderColor = UIColor.clearColor()
//    static var appBackgroundColor = UIColor.blackColor()
    static var photoTableBackgroundColor = UIColor.clearColor()

    static var imageBorderColor = UIColor.clearColor()
    static var labelColor = UIColor.lightGrayColor()
    static var appBackgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.1, alpha: 1)
    static var highlightColor = UIColor(hue:0.096, saturation:0.779, brightness:0.992, alpha:1)
    
    //    static var imageBorderColor = UIColor.lightGrayColor()
    
    
    static func setFormattingForLabels(views:[UILabel]) {
        for view in views {
            view.backgroundColor = UIColor.clearColor()
            view.textColor = C.labelColor
        }
    }
    

}



