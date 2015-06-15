//
//  contentData.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 4/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class contentData: NSObject {
	
	var picture:String
	var info:String
	
	init( picture:String, info:String) {
		
		self.picture = picture
		self.info = info
		super.init()
		
	}
	
}
