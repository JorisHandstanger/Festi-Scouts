//
//  DetailViewController.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 30/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	var badgeData:BadgeData
	
	init( badgedata:BadgeData) {
		
		self.badgeData = badgedata
		super.init(nibName: nil, bundle: nil)
		
	}
	
	override func loadView() {
		switch badgeData.view {
			case "mapDrawView":
			self.view = mapDrawView(frame: UIScreen.mainScreen().bounds)
			case "groupCameraView":
			self.view = groupCameraView(frame: UIScreen.mainScreen().bounds)
			NSNotificationCenter.defaultCenter().postNotificationName("startCapture", object: self)
			default:
			self.view = nil
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		if(self.view.isKindOfClass(groupCameraView)){
			NSNotificationCenter.defaultCenter().postNotificationName("stopCapture", object: self)
		}
		self.view = nil
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = self.badgeData.name
		
		//self.theView.updateView(self.activityData.imagename, desc: self.activityData.desc)
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}