//
//  mapDrawView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 30/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class mapDrawView: UIView, CLLocationManagerDelegate, MKMapViewDelegate {
	
	var APIUrls : NSDictionary = NSDictionary()
	var manager:CLLocationManager!
	var myLocations: [CLLocation] = []
	var coordinates: [CLLocationCoordinate2D] = []
	var pins: [PinData] = []
	var MapView:MKMapView!
	var distanceRan:CLLocationDistance = 0
	var nextPoint:Int = 0
	let notificationView = UIView(frame: CGRectMake(10, 400, 300, 150))
	let notLbl = UILabel(frame: CGRectMake(90, 6, 200, 30))
	var done : Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		loadPlist()
		
		manager = CLLocationManager()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestAlwaysAuthorization()
		manager.startUpdatingLocation()
		
		MapView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height))
		
		self.coordinates.append(CLLocationCoordinate2DMake(+37.33069642,-122.03066881))
		self.coordinates.append(CLLocationCoordinate2DMake(+37.33045275,-122.02953296))
		self.coordinates.append(CLLocationCoordinate2DMake(+37.33024463,-122.02887705))
		
		for index in 0 ... (self.coordinates.count - 1) {
			var pin = PinData(coordinate: self.coordinates[index], id: (index + 1))
			self.pins.append(pin)
			MapView.addAnnotation(pin)
		}
		
		self.addSubview(MapView)
		
		let notificationIV = UIImageView(frame: CGRectMake(0, 0, 300, 150))
		notificationIV.image = UIImage(named: "notification")
		self.notificationView.addSubview(notificationIV)
	
		self.notLbl.text = "Ga naar punt 1 om te starten!"
		self.notLbl.textColor = UIColor(red:69/255, green:78/255,blue:48/255,alpha:1.0)
		self.notLbl.font = UIFont(name: "brooklyncofferegular", size: 14)
		self.notificationView.addSubview(self.notLbl)
		
		self.addSubview(self.notificationView)
		
		let bar = UIImageView(frame: CGRectMake(0, (UIScreen.mainScreen().bounds.height - 70), UIScreen.mainScreen().bounds.width, 70))
		bar.image = UIImage(named: "bar")
		self.addSubview(bar)
		
		MapView.delegate = self
		MapView.mapType = MKMapType.Standard
		MapView.showsUserLocation = true
		
	}
	
	func loadPlist(){
		var plistPath = NSBundle.mainBundle().URLForResource("APIUrls", withExtension: "plist")
		self.APIUrls = NSDictionary(contentsOfURL: plistPath!) as! Dictionary<String, String>
	}
	
	func screenShotMethod() {
		if(!self.done){
		UIGraphicsBeginImageContext(self.frame.size)
		self.layer.renderInContext(UIGraphicsGetCurrentContext())
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
		self.uploadPicture(image!)
		}
		self.done = true
	}
	
	func uploadPicture(image:UIImage){
		
		let imageData:NSData = NSData(data: UIImageJPEGRepresentation(image, 1.0))
		SRWebClient.POST(self.APIUrls["upload"]! as! String)
			.data(imageData, fieldName:"file", data:["userId":String(NSUserDefaults.standardUserDefaults().integerForKey("userId")),"badgeId":"6"])
			.send({(response:AnyObject!, status:Int) -> Void in
				
				let data = [
					"userId": String(NSUserDefaults.standardUserDefaults().integerForKey("userId")),
					"badgeId": "4",
					"image": String(NSUserDefaults.standardUserDefaults().integerForKey("userId")) + "_4.jpg"
				]
				
				Alamofire.request(.POST, self.APIUrls["completed"]! as! String, parameters: data).responseJSON{(_, _, data, _) in
					
					NSNotificationCenter.defaultCenter().postNotificationName("reload", object: self)
					
				}
				
				},failure:{(error:NSError!) -> Void in
					//process failure response
			})
	}

	
	func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
		var currentLocation = locations[0] as! CLLocation
		
		if(self.nextPoint >= 1 && self.nextPoint <= (self.pins.count - 1)){
			myLocations.append(currentLocation)
		}
		
		
		if(self.pins.count == self.nextPoint){
			self.notificationView.alpha = 1.0
			self.notLbl.text = "'t Is gelukt!"
			screenShotMethod()
			
		}else{
			var locationFromPoint = CLLocation(coordinate: self.pins[self.nextPoint].coordinate, altitude: 1, horizontalAccuracy: 1, verticalAccuracy: -1, timestamp: nil)
			var pointDist:CLLocationDistance = locationFromPoint.distanceFromLocation(currentLocation)
			
			if(pointDist <= 10 || pointDist == 0) {
				self.pins[self.nextPoint].done = true
				var pins = self.pins
				var locations = self.myLocations
				for pin:PinData in pins{
					if(pin.done && (MapView.viewForAnnotation(pin) != nil)){
						let view:MKAnnotationView = MapView.viewForAnnotation(pin)
						view.image = UIImage(named:"anComp")
					}
				}
				if(self.nextPoint == 0){
					self.notificationView.alpha = 0
				}
				println(self.nextPoint)
				self.nextPoint++
			}
		}
		
		let spanX = 0.003
		let spanY = 0.003
		var newRegion = MKCoordinateRegion(center: MapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
		MapView.setRegion(newRegion, animated: true)
		
		if (myLocations.count > 1){
			var sourceIndex = myLocations.count - 1
			var destinationIndex = myLocations.count - 2
			let c1 = myLocations[sourceIndex].coordinate
			let c2 = myLocations[destinationIndex].coordinate
			var a = [c1, c2]
			var distance:CLLocationDistance = myLocations[sourceIndex].distanceFromLocation(myLocations[destinationIndex])
			var polyline = MKPolyline(coordinates: &a, count: a.count)
			distanceRan += distance

			MapView.addOverlay(polyline)
		}
		
	}
	
	func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
		
		if overlay is MKPolyline {
			var polylineRenderer = MKPolylineRenderer(overlay: overlay)
			polylineRenderer.strokeColor = UIColor(red: 228/255, green: 80/255, blue: 51/255, alpha: 1.0)
			polylineRenderer.lineWidth = 4
			return polylineRenderer
		}
		return nil
	}
	
	func mapView(mapView:MKMapView!, viewForAnnotation annotation:MKAnnotation!) -> MKAnnotationView!{
		let reuseId = "test"
		
		var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
		if anView == nil {
			anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			
			if annotation.isKindOfClass(PinData) {
				let an = annotation as! PinData
				
				if(an.done){
					anView.image = UIImage(named:"anComp")
				}else{
					anView.image = UIImage(named:"anDot")
				}
				
				let lblNumber = UILabel(frame: CGRectMake(10, 10, 20, 20))
				
				lblNumber.text = String(an.id)
				lblNumber.textColor = UIColor.blackColor()
				lblNumber.font = UIFont(name: "Bariol-Regular", size: 15)
				anView.addSubview(lblNumber)

				
				anView.layer.anchorPoint.x = 1.35
				anView.layer.anchorPoint.y = -1.2
			}
			
			if annotation.isKindOfClass(MKUserLocation) {
				return nil;
			}
		}
		
		return anView
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
