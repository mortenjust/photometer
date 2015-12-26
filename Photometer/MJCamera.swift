//
//  MJCamera.swift
//  Photometer
//
//  Created by Morten Just Petersen on 12/25/15.
//  Copyright © 2015 Morten Just Petersen. All rights reserved.
//

import UIKit
import AVFoundation

protocol MJCameraDelegate {
    func mJCameraImageFinishedSaving(image:UIImage)
}

class MJCamera : NSObject {
    var captureDevice : AVCaptureDevice?
    let captureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer?
    var previewView:UIView?
    var stillImageOutput: AVCaptureStillImageOutput!
    var delegate : MJCameraDelegate?
    
    init(previewView _previewView:UIView?) {
        previewView = _previewView
    }
    
    
    func start(){
        getCameraAndBeginSession()
    }
    
    func getCameraAndBeginSession(){
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if device.hasMediaType(AVMediaTypeVideo){
                if device.position == .Back {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        beginSession()
                    }
                }
            }
        }
    }
    
    private func beginSession(){
        configureDevice()
        do {
        try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            print("can't addInput") // TODO: Handle throw
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        previewView?.layer.addSublayer(previewLayer!)
        previewLayer?.frame = previewView!.frame

        stillImageOutput = AVCaptureStillImageOutput()
        captureSession.addOutput(stillImageOutput)
        captureSession.startRunning()
    }
    
    
    func captureImage(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            var videoConnection : AVCaptureConnection?
            for connection in self.stillImageOutput.connections {
                for port in connection.inputPorts! {
                    if port.mediaType == AVMediaTypeVideo {
                        videoConnection = connection as? AVCaptureConnection;
                        break;
                    }
                }
                if (videoConnection != nil) {
                    break
                }
            }
            
            self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (imageSampleBuffer:CMSampleBuffer!, _) -> Void in
                let imageDataJpeg = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
                let pickedImage = UIImage(data: imageDataJpeg)
                UIImageWriteToSavedPhotosAlbum(pickedImage!, self, "imageSaved:didFinishSavingWithError:contextInfo:", nil)
            })
            
        }
    }
    
    
     func imageSaved(image: UIImage, didFinishSavingWithError error: NSError,
        contextInfo: UnsafeMutablePointer<Void>){
            if error.code != 0 {
                print(">> Error : \(error.localizedDescription)")
            } else {
                print("Saving done!!")
                delegate?.mJCameraImageFinishedSaving(image)
            }
    }
    
    private func configureDevice(){
        if let device = captureDevice {
            do {
            try device.lockForConfiguration()
                device.focusMode = .ContinuousAutoFocus
                device.unlockForConfiguration()
            } catch {
                print("Couldn't lock for config") // TODO: Add throw handling
            }
        }
    }    
}
