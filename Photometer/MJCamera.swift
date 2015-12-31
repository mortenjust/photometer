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

class MJCamera : NSObject, AVCaptureMetadataOutputObjectsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CameraOverlayDelegate {
    var captureDevice : AVCaptureDevice?
    let captureSession = AVCaptureSession()
    var previewLayer:AVCaptureVideoPreviewLayer?
    var previewView:UIView?
    var stillImageOutput: AVCaptureStillImageOutput!
    var delegate : MJCameraDelegate?
    var vc:ViewController!
    var picker:UIImagePickerController!
    
    init(previewView _previewView:UIView?) {
        super.init()
        previewView = _previewView
    }
    
    override init(){
        super.init()
    }
    
    func startCamera(){}
    
    func startSimpleCamera(){
        picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.delegate = self
        
        picker.cameraFlashMode = .Auto
//        picker.cameraViewTransform
        
        let frame = CGRectMake(0 , 0 , 105, 105)
        let overlayView = CameraOverlayView(frame:  frame)
        overlayView.delegate = self
        picker.cameraOverlayView = overlayView

        picker.showsCameraControls = false

        picker.allowsEditing = false
        vc.presentViewController(picker, animated: true) { () -> Void in
            
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        // TODO: Save image here. Shit, I'm starting to think it doesn't have the full thing either. But the viewcontroller is a better experience though.
        saveImage(image)
    }
    
    func cameraOverlayShutterClicked() {
        picker.takePicture()
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
        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureSession.addOutput(metadataOutput)
        
        captureSession.addOutput(stillImageOutput)
        captureSession.startRunning()
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
//        for metadata in metadataObjects {
//
//        }
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
                self.saveImage(pickedImage!)
            })
            
        }
    }
    
    
    func saveImage(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, "imageSaved:didFinishSavingWithError:contextInfo:", nil)
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
            } catch let error {
                print("Couldn't lock for config: \(error)")
            }
        }
    }    
}
