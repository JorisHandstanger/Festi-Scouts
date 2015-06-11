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
	
	init( id:Int, name:String, desc:String, interactable:Bool, done:Bool, image:String, view:String ) {
		
		self.id = id
		self.name = name
		self.desc = desc
		self.interactable = interactable
		self.done = done
		self.image = image
		self.view = view
		super.init()
		
	}
}
