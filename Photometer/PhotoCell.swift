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

protocol PhotoCellDelegate {
    func photoCellWantsTableUpdate()
}

class PhotoCell: UITableViewCell, MJCameraDelegate {
    @IBOutlet weak var timeTaken: UILabel!
    @IBOutlet weak var photo: UIImageView!
    weak var meterImage:MeterImage?
    @IBOutlet weak var locationLabel: UILabel!
    var camera : MJCamera!
    var delegate:PhotoCellDelegate?
    var vc : ViewController!
    
    func resetAllLabels(){
        timeTaken.text = ""
        locationLabel.text = ""
    }
    
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
    
    func leaveViewPort(){
        if let cellPhoto = photo {
            cellPhoto.alpha = 0
            cellPhoto.image = nil
            
            removeCameraButtonIfNecessary()
            if let c = camera {
                c.captureSession.stopRunning()
                c.previewLayer?.removeFromSuperlayer()
            }
        }
    }
    
    func removeCameraButtonIfNecessary(){
        if let cellPhoto = photo {
            if let gestures = cellPhoto.gestureRecognizers {
                for g in gestures {
                    cellPhoto.removeGestureRecognizer(g)
                }
            }
            photo.userInteractionEnabled = false
            photo.backgroundColor = UIColor.clearColor()
        }
    }
    
    func showCameraButton(){
        photo.image = UIImage(named: "camera")
        let tap = UITapGestureRecognizer(target: self, action: "startCamera")
        photo.userInteractionEnabled = true
        photo.addGestureRecognizer(tap)
        self.didEnterViewPort()
        photo.backgroundColor = UIColor.blackColor()
    }
    
    func startCamera(){
        let frame = CGRectMake(0, 0, photo.frame.size.width+30, photo.frame.size.height+30)
        let p = UIView(frame: frame)
        photo.addSubview(p)
        
        camera = MJCamera()
        camera.delegate = self
        camera.vc = self.vc
        camera.startSimpleCamera()
    }
    
    func mJCameraImageFinishedSaving(image: UIImage) {
        delegate?.photoCellWantsTableUpdate()
    }
    
    func didEnterViewPort(){
        UIView.animateWithDuration(0.1, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.photo.alpha = 1
            self.photo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1,1);
            }, completion: nil)
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
