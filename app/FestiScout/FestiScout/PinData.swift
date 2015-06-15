//
//  PinData.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 15/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import MapKit

class PinData: NSObject, MKAnnotation {
	
	var id:Int
	var coordinate:CLLocationCoordinate2D
	var done:Bool = false
	
	init(coordinate:CLLocationCoordinate2D, id:Int) {
		self.coordinate = coordinate
		self.id = id
	}
	
	
}