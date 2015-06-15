//
//  BadgeData.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 29/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class BadgeData: NSObject {
	var id:Int
	var name:String
	var desc:String
	var interactable:Bool
	var done:Bool
	var image:String
	var view:String
	var tijd:Int
	var plezier:Int
	var peerPlezier:Int
	
	init( id:Int, name:String, desc:String, interactable:Bool, done:Bool, image:String, view:String, tijd:Int, plezier:Int, peerPlezier:Int ) {
		
		self.id = id
		self.name = name
		self.desc = desc
		self.interactable = interactable
		self.done = done
		self.image = image
		self.view = view
		self.tijd = tijd
		self.plezier = plezier
		self.peerPlezier = peerPlezier
		super.init()
		
	}
}
