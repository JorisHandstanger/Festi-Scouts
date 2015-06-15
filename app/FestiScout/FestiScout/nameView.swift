//
//  nameView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 5/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class nameView: UIView {
	/*
	// Only override drawRect: if you perform custom drawing.
	// An empty implementation adversely affects performance during animation.
	override func drawRect(rect: CGRect) {
	// Drawing code
	}
	*/
	
	
	let btn = UIButton(frame: CGRectMake((UIScreen.mainScreen().bounds.width/2) - 50, 400, 100, 50))
	var navC:UINavigationController
	
	init(frame: CGRect, navigationController:UINavigationController) {
		self.navC = navigationController
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clearColor()
		
		let imageView = UIImageView(image: UIImage(named: "tutbg"))
		imageView.frame = CGRectMake(16, 47, 283, 474)
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(imageView)
		
		let image = UIImage(named: "tutTotem")
		let imageView2 = UIImageView(image: image)
		imageView2.frame = CGRectMake(35, 70, image!.size.width, image!.size.height)
		imageView2.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(imageView2)
		
		let desclbl = UITextView(frame: CGRectMake(50, 200, UIScreen.mainScreen().bounds.width - 100, 400))
		desclbl.text = "welkom " + NSUserDefaults.standardUserDefaults().stringForKey("userTotem")! + " bij de festiscouts. We hebben voor jou " + NSUserDefaults.standardUserDefaults().stringForKey("userTotem")! + " gekozen omdat... Ik denk dat het vrij duidelijk is eigelijk."
		desclbl.editable = false
		desclbl.textColor = UIColor(red: 69/255, green: 78/255, blue: 48/255, alpha: 1.0)
		desclbl.textAlignment = NSTextAlignment.Center
		desclbl.backgroundColor = UIColor.clearColor()
		desclbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
		self.addSubview(desclbl)
		
		self.createButton()
	}
	
	func createButton() {
		self.btn.setTitle("Ok.", forState: UIControlState.Normal)
		self.btn.titleLabel!.font = UIFont(name: "HelveticaNeue", size: CGFloat(25))
		self.btn.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
		self.btn.titleLabel!.textAlignment = NSTextAlignment.Center
		self.addSubview(btn)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
