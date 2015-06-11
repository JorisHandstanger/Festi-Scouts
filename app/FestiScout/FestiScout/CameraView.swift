//
//  CameraView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 11/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
	var captureSession: AVCaptureSession?
	var stillImageOutput: AVCaptureStillImageOutput?
	var previewLayer: AVCaptureVideoPreviewLayer?
	
	let previewView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 400))
	let capturedImage = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 400))
	let takePhotoButton = UIButton(frame: CGRectMake(20, 420, 50, 20))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.addSubview(self.previewView)
		self.addSubview(self.capturedImage)
		self.takePhotoButton.backgroundColor = UIColor.whiteColor()
		self.takePhotoButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
		self.addSubview(self.takePhotoButton)
		
		//cameraaassszzz
		
		captureSession = AVCaptureSession()
		captureSession!.sessionPreset = AVCaptureSessionPresetPhoto
		
		var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		
		var error: NSError?
		var input = AVCaptureDeviceInput(device: backCamera, error: &error)
		
		if error == nil && captureSession!.canAddInput(input) {
			captureSession!.addInput(input)
			
			stillImageOutput = AVCaptureStillImageOutput()
			stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
			if captureSession!.canAddOutput(stillImageOutput) {
				captureSession!.addOutput(stillImageOutput)
				
				previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
				previewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
				previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
				previewView.layer.addSublayer(previewLayer)
				
				captureSession!.startRunning()
			}
		}
		
		previewLayer!.frame = previewView.bounds
		
	}
	
	
	func pressed(sender: UIButton!) {
		if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
			videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
			stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
				if (sampleBuffer != nil) {
					var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
					var dataProvider = CGDataProviderCreateWithCFData(imageData)
					var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
					
					var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
					self.capturedImage.image = image
				}
			})
		}
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
