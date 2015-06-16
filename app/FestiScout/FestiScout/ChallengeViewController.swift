//
//  DetailViewController.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 30/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
	
	var badgeData:BadgeData
	
	init( badgedata:BadgeData) {
		
		self.badgeData = badgedata
		super.init(nibName: nil, bundle: nil)
		self.navigationController?.navigationBarHidden = true
		
	}
	
	override func loadView() {
		switch badgeData.view {
			case "mapDrawView":
			self.view = mapDrawView(frame: UIScreen.mainScreen().bounds)
			case "groupCameraView":
			self.view = groupCameraView(frame: UIScreen.mainScreen().bounds)
			default:
			self.view = nil
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.view = nil
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Custom back button
		var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
		backButton.addTarget(self, action: "popToRoot:", forControlEvents: UIControlEvents.TouchUpInside)
		backButton.frame = CGRectMake(5, 5, 58, 18)
		backButton.setBackgroundImage(UIImage(named: "backBtn1"), forState: UIControlState.Normal)
		var myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: backButton)
		self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
		
		// Titel
		let lblTitel = UILabel(frame: CGRectMake(0, 0, 175, 40))
		lblTitel.text = badgeData.name
		lblTitel.textColor = UIColor(red:240/255, green:232/255,blue:183/255,alpha:1.0)
		lblTitel.font = UIFont(name: "BigNoodleTitling", size: 30)
		lblTitel.adjustsFontSizeToFitWidth = true
		lblTitel.textAlignment =  NSTextAlignment.Center
		
		self.navigationItem.titleView = lblTitel
		
		//self.theView.updateView(self.activityData.imagename, desc: self.activityData.desc)
		
	}
	
	func popToRoot(sender:UIBarButtonItem){
		let badgecount = self.navigationController?.navigationBar.subviews.filter { ($0 as! UIView).frame == CGRectMake(0, 0, 49, 44) }
		let result = badgecount?.first as! UIView
		result.alpha = 1
		self.navigationController!.popToRootViewControllerAnimated(true)
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