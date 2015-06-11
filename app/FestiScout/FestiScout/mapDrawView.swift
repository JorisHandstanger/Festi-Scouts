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

class mapDrawView: UIView, CLLocationManagerDelegate, MKMapViewDelegate {
	
	var manager:CLLocationManager!
	var myLocations: [CLLocation] = []
	var MapView:MKMapView!
	var distanceRan:CLLocationDistance = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		manager = CLLocationManager()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.requestAlwaysAuthorization()
		manager.startUpdatingLocation()
		
		MapView = MKMapView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height))
		MapView.delegate = self
		MapView.mapType = MKMapType.Standard
		MapView.showsUserLocation = true
		self.addSubview(MapView)
		
	}
	
	func locationManager(manager:CLLocationManager, didUpdateLocations locations:[AnyObject]) {
		myLocations.append(locations[0] as! CLLocation)
		
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
			//var map: UIImage = MKPolyline(coordinates: &a, count: a.count)
			distanceRan += distance
			println(distanceRan)
			//MapView.addOverlay(map)
			MapView.addOverlay(polyline)
		}
	}
	
	func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
		/*if overlay is ParkMapOverlay {
		let magicMountainImage = UIImage(named: "overlay_park")
		let overlayView = ParkMapOverlayView(overlay: overlay, overlayImage: magicMountainImage!)
		
		return overlayView
		}*/
		
		if overlay is MKPolyline {
			var polylineRenderer = MKPolylineRenderer(overlay: overlay)
			polylineRenderer.strokeColor = UIColor.blueColor()
			polylineRenderer.lineWidth = 4
			return polylineRenderer
		}
		return nil
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
