//
//  PhotoCellTableViewCell.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/21/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var timeTaken: UILabel!
    @IBOutlet weak var photo: UIImageView!
    var meterImage = MeterImage()
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeTaken.layer.cornerRadius = timeTaken.frame.height/2
        timeTaken.clipsToBounds = true

        photo.clipsToBounds = true
        photo.layer.cornerRadius = 130/2
        photo.layer.borderColor = C.imageBorderColor.CGColor
        photo.layer.borderWidth = 1.0
        backgroundColor = UIColor.clearColor()
        
        C.setFormattingForLabels([locationLabel])
    }
    
    func prepareToEnterViewport(){
            photo.alpha = 0
            photo.image = nil
            photo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);

    }
    
    func didEnterViewPort(){
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.photo.alpha = 1
            self.photo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1,1);
            }, completion: nil)
    }
    
    
    
    func getImage(){
        print("getimage")
        meterImage.getImage { (image) -> Void in
            self.photo.image = image
            self.didEnterViewPort()
        }
    }
    
    func setAddressString(location:CLLocation){
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) -> Void in
            
            if let p = placemarks {
                let address = p[0].name!
                
                self.locationLabel.text = address

            } else {
                self.locationLabel.text = ""
            }
        }
    }
    
    func updateTimeTaken(taken:NSDate){
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        let dateString = formatter.stringFromDate(taken)
        timeTaken.text = " \(dateString)  "
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
