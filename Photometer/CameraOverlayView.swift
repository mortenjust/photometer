//
//  CameraOverlayView.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/26/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit

protocol CameraOverlayDelegate {
    func cameraOverlayShutterClicked()
}

class CameraOverlayView: UIView {
    var delegate:CameraOverlayDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
        backgroundColor = UIColor.clearColor()
        userInteractionEnabled = false
        setup()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    func setup(){
        userInteractionEnabled = true   
        let cameraButton = UIImageView(image: UIImage(named: "camera")!)
        cameraButton.center.x = self.center.x
        cameraButton.userInteractionEnabled = true
        let cameraClick = UITapGestureRecognizer(target: self, action: "shutterClicked")
        cameraButton.addGestureRecognizer(cameraClick)
        let screen = UIScreen.mainScreen().bounds
        center.x = screen.size.width/2
        center.y = screen.size.height - bounds.height
        addSubview(cameraButton)
    }
    
    func shutterClicked(){
        delegate?.cameraOverlayShutterClicked()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
