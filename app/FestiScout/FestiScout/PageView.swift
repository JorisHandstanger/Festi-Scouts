//
//  PageView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 4/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class PageView: UIView {

	
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	
	let btn = UIButton(frame: CGRectMake((UIScreen.mainScreen().bounds.width/2) - 50, 400, 100, 50))
	var content:contentData
	var navC:UINavigationController
	
	init(frame: CGRect, content:contentData, navigationController:UINavigationController) {
		self.content = content
		self.navC = navigationController
		super.init(frame: frame)
		
		self.loadImage("ipadplaceholder")
		self.backgroundColor = UIColor.whiteColor()
		
		self.createTitle()
		self.createButton()
	}
	
	func createButton() {
		self.btn.setTitle("Next", forState: UIControlState.Normal)
		self.btn.titleLabel!.font = UIFont(name: "HelveticaNeue", size: CGFloat(25))
		self.btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		self.btn.titleLabel!.textAlignment = NSTextAlignment.Center
		self.addSubview(btn)
	}
	
	func createTitle() {
		
		let titlelbl = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
		titlelbl.text = content.titel
		
		titlelbl.textAlignment = NSTextAlignment.Center
		
		titlelbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(30))
		
		self.addSubview(titlelbl)
		
		let desclbl = UITextView(frame: CGRectMake(20, 320, UIScreen.mainScreen().bounds.width - 40, 400))
		desclbl.text = content.info
		desclbl.editable = false
		
		desclbl.textAlignment = NSTextAlignment.Left
		
		desclbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
		
		self.addSubview(desclbl)
	}
	
	func loadImage(name:String) {
		let image = UIImage(named: content.picture)
		let imageView = UIImageView(image: image)
		imageView.frame = CGRectMake(0, 100, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height/2.8)
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(imageView)
	}
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
