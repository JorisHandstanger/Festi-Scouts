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
	
	var content:contentData
	var navC:UINavigationController
	
	init(frame: CGRect, content:contentData, navigationController:UINavigationController) {
		self.content = content
		self.navC = navigationController
		super.init(frame: frame)
		
		self.backgroundColor = UIColor.clearColor()
		
		let imageView = UIImageView(image: UIImage(named: "tutbg"))
		imageView.frame = CGRectMake(16, 47, 283, 474)
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(imageView)
		
		let image = UIImage(named: content.picture)
		let imageView2 = UIImageView(image: image)
		imageView2.frame = CGRectMake(35, 70, image!.size.width, image!.size.height)
		imageView2.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(imageView2)
		
		let desclbl = UITextView(frame: CGRectMake(50, image!.size.height + 70, UIScreen.mainScreen().bounds.width - 100, 400))
		desclbl.text = content.info
		desclbl.editable = false
		desclbl.textColor = UIColor(red: 69/255, green: 78/255, blue: 48/255, alpha: 1.0)
		desclbl.textAlignment = NSTextAlignment.Center
		desclbl.backgroundColor = UIColor.clearColor()
		desclbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
		self.addSubview(desclbl)
		
		
		
	}
	
	func loadImage(name:String) {
		
	}
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
