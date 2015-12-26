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
    var meterImage = MeterImage()
    @IBOutlet weak var locationLabel: UILabel!
    var camera : MJCamera!
    var delegate:PhotoCellDelegate?
    
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
        print("preparetoenterviewport!")
        if let cellPhoto = photo {
            cellPhoto.alpha = 0
            cellPhoto.image = UIImage(named: "placeholder")
            cellPhoto.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
            }
        if let c = camera {
            c.captureSession.stopRunning()
            c.previewLayer?.removeFromSuperlayer()
        }
    }
    
    func showCameraButton(){
        print("showCameraButton")
        photo.image = UIImage(named: "camera")
        let tap = UITapGestureRecognizer(target: self, action: "startCamera")
        photo.userInteractionEnabled = true
        photo.addGestureRecognizer(tap)
        self.didEnterViewPort()
        photo.backgroundColor = UIColor.blackColor()
    }
    
    func startCamera(){
        print("Startcamera!")
        let frame = CGRectMake(0, 0, photo.frame.size.width+30, photo.frame.size.height+30)
        let p = UIView(frame: frame)
        photo.addSubview(p)
        camera = MJCamera(previewView: p)
        camera.start()
        camera.delegate = self
        NSTimer.after(1.second) { () -> Void in
            self.camera.captureImage()
            // calls mJcameraImageFinishedSaving when done
        }
    }
    
    func mJCameraImageFinishedSaving(image: UIImage) {

        print("DONE taking that photo")
        delegate?.photoCellWantsTableUpdate()
    }
    
    
    func didEnterViewPort(){
        print("didEnterViewPort!")
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { () -> Void in
            self.photo.alpha = 1
            self.photo.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1,1);
            }, completion: nil)
    }
    
    
    
    func getImage(){
        print("getimage")
        meterImage.getImage { (image) -> Void in
            let i = image
            self.photo.image = i
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
