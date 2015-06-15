//
//  groupCameraView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 10/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
import SwiftyJSON
import AVFoundation
import CoreImage
import CoreMedia
import ImageIO
import AssetsLibrary

class groupCameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	let previewView = UIView(frame: CGRectMake(0, 10, UIScreen.mainScreen().bounds.width, 500))
	let switchCamera = UISegmentedControl(items: ["Front", "Back"])
	let capturedImage = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 400))
	let takePhotoButton = UIButton(frame: CGRectMake(100, 500, 100, 40))
	
	var APIUrls : NSDictionary = NSDictionary()
	
	var previewLayer : AVCaptureVideoPreviewLayer!
	var videoDataOutput : AVCaptureVideoDataOutput!
	var detectFaces : Bool!
	var videoDataOutputQueue : dispatch_queue_t!
	var stillImageOutput : AVCaptureStillImageOutput!
	var flashView : UIView!
	var square : UIImage!
	var isUsingFrontFacingCamera : Bool!
	var faceDetector : CIDetector!
	var beginGestureScale : CGFloat!
	var effectiveScale : CGFloat!
	var photoLocked : Bool! = true
	
	// MARKS: Actions
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		loadPlist()
		
		previewView.backgroundColor = UIColor.blackColor()
		self.addSubview(self.previewView)
		
		self.switchCamera.selectedSegmentIndex = 0
		self.switchCamera.frame = CGRectMake(0, 500, 80, 40)
		self.switchCamera.addTarget(self, action: "switchCameras:", forControlEvents: .ValueChanged)
		self.addSubview(self.switchCamera)
		
		self.addSubview(self.capturedImage)
		
		self.takePhotoButton.backgroundColor = UIColor.redColor()
		self.takePhotoButton.addTarget(self, action: "takePicture:", forControlEvents: .TouchUpInside)
		self.addSubview(self.takePhotoButton)
		
		self.startCapture()
	}
	
	func loadPlist(){
		var plistPath = NSBundle.mainBundle().URLForResource("APIUrls", withExtension: "plist")
		self.APIUrls = NSDictionary(contentsOfURL: plistPath!) as! Dictionary<String, String>
	}
	
	func takePicture(sender: UIButton!) {
		if(!self.photoLocked){
			println("take picture")
			videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).enabled = false
			if let videoConnection = self.stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) {
				videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
				self.stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error) in
					if (sampleBuffer != nil) {
						var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
						var dataProvider = CGDataProviderCreateWithCFData(imageData)
						var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
						
						var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
						self.capturedImage.image = image
						UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
						
						self.uploadPicture(image!)
					}
				})
			}
			videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).enabled = true
			
		}
	}
	
	func uploadPicture(image:UIImage){
		
		let imageData:NSData = NSData(data: UIImageJPEGRepresentation(image, 1.0))
		SRWebClient.POST(self.APIUrls["upload"]! as! String)
			.data(imageData, fieldName:"file", data:["userId":String(NSUserDefaults.standardUserDefaults().integerForKey("userId")),"badgeId":"9"])
			.send({(response:AnyObject!, status:Int) -> Void in
				
		
				let data = [
					"userId": String(NSUserDefaults.standardUserDefaults().integerForKey("userId")),
					"badgeId": "9",
					"image": String(NSUserDefaults.standardUserDefaults().integerForKey("userId")) + "_9.jpg"
				]
				
				Alamofire.request(.POST, self.APIUrls["completed"]! as! String, parameters: data).responseJSON{(_, _, data, _) in
					
					NSNotificationCenter.defaultCenter().postNotificationName("reload", object: self)
					
				}
				},failure:{(error:NSError!) -> Void in
					//process failure response
			})
	}
	
	func startCapture() {
		setupAVCapture()
		square = UIImage(named: "facedetect")
		
		faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh, CIDetectorTracking: true])
		
		detectFaces = true
		videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).enabled = detectFaces
		if !detectFaces {
			
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.drawFaceBoxesForFeatures([], clap: CGRectZero, orientation: UIDeviceOrientation.Portrait)
			})
		}
	}
	
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func switchCameras (sender : UISegmentedControl!) {
		var desiredPosition : AVCaptureDevicePosition
		desiredPosition = isUsingFrontFacingCamera == true ? AVCaptureDevicePosition.Back : AVCaptureDevicePosition.Front
		
		for d in AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo) as! [AVCaptureDevice] {
			
			if d.position == desiredPosition {
				
				previewLayer.session.beginConfiguration()
				
				var input : AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(d, error: nil) as! AVCaptureDeviceInput
				for oldInput in previewLayer.session.inputs as! [AVCaptureInput] {
					previewLayer.session.removeInput(oldInput)
				}
				
				previewLayer.session.addInput(input)
				previewLayer.session.commitConfiguration()
			}
		}
		
		isUsingFrontFacingCamera = !isUsingFrontFacingCamera
	}
	
	
	// Setup functions
	
	func setupAVCapture() {
		
		var error : NSError?
		
		var session : AVCaptureSession = AVCaptureSession()
		session.sessionPreset = AVCaptureSessionPreset640x480
		
		// Select a video device, make an input
		var device : AVCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
		var deviceInput : AVCaptureDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(device, error:&error) as! AVCaptureDeviceInput
		
		isUsingFrontFacingCamera = false
		detectFaces = false
		
		if session.canAddInput(deviceInput) {
			session.addInput(deviceInput)
		}
		
		// Foto output
		
		stillImageOutput = AVCaptureStillImageOutput()
		stillImageOutput!.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
		
		// Video output
		videoDataOutput = AVCaptureVideoDataOutput()
		
		videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCMPixelFormat_32BGRA as NSNumber]
		videoDataOutput.alwaysDiscardsLateVideoFrames = true
		
		videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL)
		videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
		
		if session.canAddOutput(videoDataOutput) && session.canAddOutput(stillImageOutput){
			session.addOutput(stillImageOutput)
			session.addOutput(videoDataOutput)
		}
		videoDataOutput.connectionWithMediaType(AVMediaTypeVideo).enabled = false
		
		effectiveScale = 1.0
		
		previewLayer = AVCaptureVideoPreviewLayer(session: session)
		previewLayer.backgroundColor = UIColor.blackColor().CGColor
		previewLayer.videoGravity = AVLayerVideoGravityResizeAspect
		var rootLayer : CALayer = previewView.layer
		rootLayer.masksToBounds = true
		previewLayer.frame = rootLayer.bounds
		rootLayer.addSublayer(previewLayer)
		session.startRunning()
	}
	
	func stopCapture() {
		println("Stopping capture")
		videoDataOutput = nil
		videoDataOutputQueue = nil
		previewLayer.removeFromSuperlayer()
		previewLayer = nil
	}
	
	// MARK: Delegates
	
	func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
		// got an image
		let pixelBuffer : CVPixelBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)
		let attachments : [NSObject: AnyObject] = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, pixelBuffer, CMAttachmentMode( kCMAttachmentMode_ShouldPropagate)).takeRetainedValue() as [NSObject : AnyObject]
		
		let ciImage : CIImage = CIImage(CVPixelBuffer: pixelBuffer, options: attachments)
		
		let curDeviceOrientation : UIDeviceOrientation = UIDevice.currentDevice().orientation
		var exifOrientation : Int
		
		enum DeviceOrientation : Int {
			case PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
			PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
			PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
			PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
			PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
			PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
			PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
			PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
		}
		
		switch curDeviceOrientation {
			
		case UIDeviceOrientation.PortraitUpsideDown:
			exifOrientation = DeviceOrientation.PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM.rawValue
		case UIDeviceOrientation.LandscapeLeft:
			if isUsingFrontFacingCamera == true {
				exifOrientation = DeviceOrientation.PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT.rawValue
			} else {
				exifOrientation = DeviceOrientation.PHOTOS_EXIF_0ROW_TOP_0COL_LEFT.rawValue
			}
		case UIDeviceOrientation.LandscapeRight:
			if isUsingFrontFacingCamera == true {
				exifOrientation = DeviceOrientation.PHOTOS_EXIF_0ROW_TOP_0COL_LEFT.rawValue
			} else {
				exifOrientation = DeviceOrientation.PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT.rawValue
			}
		default:
			exifOrientation = DeviceOrientation.PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP.rawValue
		}
		
		var imageOptions : NSDictionary = [CIDetectorImageOrientation : NSNumber(integer: exifOrientation), CIDetectorSmile : true, CIDetectorEyeBlink : true]
		
		var features = faceDetector.featuresInImage(ciImage, options: imageOptions as [NSObject : AnyObject])
		
		// the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
		// that represents image data valid for display.
		var fdesc : CMFormatDescriptionRef = CMSampleBufferGetFormatDescription(sampleBuffer)
		var clap : CGRect = CMVideoFormatDescriptionGetCleanAperture(fdesc, 0)
		
		dispatch_async(dispatch_get_main_queue(), { () -> Void in
			self.drawFaceBoxesForFeatures(features, clap: clap, orientation: curDeviceOrientation)
		})
	}
	
	func drawFaceBoxesForFeatures(features : NSArray, clap : CGRect, orientation : UIDeviceOrientation) {
		
		var sublayers : NSArray = previewLayer.sublayers
		var sublayersCount : Int = sublayers.count
		var currentSublayer : Int = 0
		var featuresCount : Int = features.count
		var currentFeature : Int = 0
		
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
		
		// cirkels verbergen
		for layer in sublayers as! [CALayer] {
			if (layer.name != nil && layer.name == "FaceLayer") {
				layer.hidden = true
			}
		}
		
		if ( features.count == 0 || !detectFaces ) {
			CATransaction.commit()
			return
		}
		
		if ( features.count >= 3){
			self.takePhotoButton.backgroundColor = UIColor.greenColor()
			self.photoLocked = false
		}else{
			self.takePhotoButton.backgroundColor = UIColor.redColor()
			self.photoLocked = true
		}
		
		//println(features.count)
		
		var parentFrameSize : CGSize = previewView.frame.size
		var gravity : NSString = previewLayer.videoGravity
		
		let previewBox : CGRect = videoPreviewBoxForGravity(gravity, frameSize: parentFrameSize, apertureSize: clap.size)
		
		for ff in features as! [CIFaceFeature] {
			var faceRect : CGRect = ff.bounds
			
			// flip preview width and height
			var temp : CGFloat = faceRect.width
			faceRect.size.width = faceRect.height
			faceRect.size.height = temp
			temp = faceRect.origin.x
			faceRect.origin.x = faceRect.origin.y
			faceRect.origin.y = temp
			
			// scale coordinates so they fit in the preview box, which may be scaled
			let widthScaleBy = previewBox.size.width / clap.size.height
			let heightScaleBy = previewBox.size.height / clap.size.width
			faceRect.size.width *= widthScaleBy
			faceRect.size.height *= heightScaleBy
			
			faceRect.origin.x *= widthScaleBy
			
			if(isUsingFrontFacingCamera == true){
				faceRect.origin.x = UIScreen.mainScreen().bounds.width - (faceRect.origin.x + faceRect.size.width)
			}
			
			faceRect.origin.y *= heightScaleBy
			
			faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y)
			
			var featureLayer : CALayer? = nil
			// re-use an existing layer if possible
			
			while (featureLayer == nil) && (currentSublayer < sublayersCount) {
				
				var currentLayer : CALayer = sublayers.objectAtIndex(currentSublayer++) as! CALayer
				
				if currentLayer.name == nil {
					continue
				}
				var name : NSString = currentLayer.name
				if name.isEqualToString("FaceLayer") {
					featureLayer = currentLayer;
					currentLayer.hidden = false
				}
			}
			
			// create a new one if necessary
			if featureLayer == nil {
				featureLayer = CALayer()
				featureLayer?.contents = square.CGImage
				featureLayer?.name = "FaceLayer"
				previewLayer.addSublayer(featureLayer)
			}
			
			
			featureLayer?.frame = faceRect
			
			currentFeature++
		}
		
		CATransaction.commit()
	}
	
	// find where the video box is positioned within the preview layer based on the video size and gravity
	func videoPreviewBoxForGravity(gravity : NSString, frameSize : CGSize, apertureSize : CGSize) -> CGRect {
		let apertureRatio : CGFloat = apertureSize.height / apertureSize.width
		let viewRatio : CGFloat = frameSize.width / frameSize.height
		
		var size : CGSize = CGSizeZero
		if gravity.isEqualToString(AVLayerVideoGravityResizeAspectFill) {
			if viewRatio > apertureRatio {
				size.width = frameSize.width
				size.height = apertureSize.width * (frameSize.width / apertureSize.height)
			} else {
				size.width = apertureSize.height * (frameSize.height / apertureSize.width)
				size.height = frameSize.height
			}
		} else if gravity.isEqualToString(AVLayerVideoGravityResizeAspect) {
			if viewRatio > apertureRatio {
				size.width = apertureSize.height * (frameSize.height / apertureSize.width)
				size.height = frameSize.height
			} else {
				size.width = frameSize.width
				size.height = apertureSize.width * (frameSize.width / apertureSize.height)
			}
		} else if gravity.isEqualToString(AVLayerVideoGravityResize) {
			size.width = frameSize.width
			size.height = frameSize.height
		}
		
		var videoBox : CGRect = CGRectZero
		videoBox.size = size
		if size.width < frameSize.width {
			videoBox.origin.x = (frameSize.width - size.width) / 2;
		} else {
			videoBox.origin.x = (size.width - frameSize.width) / 2;
		}
		
		if size.height < frameSize.height {
			videoBox.origin.y = (frameSize.height - size.height) / 2;
		} else {
			videoBox.origin.y = (size.height - frameSize.height) / 2;
		}
		
		return videoBox
	}
}
