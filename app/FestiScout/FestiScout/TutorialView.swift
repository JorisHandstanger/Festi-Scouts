//
//  TutorialView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 4/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class TutorialView: UIView, UIScrollViewDelegate {

	let scrollView: UIScrollView
	
	var tutorialContent:Array<contentData>! = Array<contentData>()
	var previousPage = 0;
	let square1 = UIView(frame: CGRectMake(30, 500, 20, 20))
	let square2 = UIView(frame: CGRectMake(55, 500, 20, 20))
	let square3 = UIView(frame: CGRectMake(80, 500, 20, 20))
	let square4 = UIView(frame: CGRectMake(105, 500, 20, 20))
	
	init(frame: CGRect, navigationController:UINavigationController) {
		
		let p1 = contentData(titel: "Welkom kadet", picture: "placeHolder", info: "lorem ipsum")
		let p2 = contentData(titel: "Badges", picture: "placeHolder", info: "lorem ipsum")
		let p3 = contentData(titel: "Word leiding", picture: "placeHolder", info: "lorem ipsum")
		
		self.tutorialContent = [p1, p2, p3]
		
		self.scrollView = UIScrollView(frame: frame)
		super.init(frame: frame)
		
		self.scrollView.delegate = self
		
		
		self.backgroundColor = UIColor.redColor()
		
		let backColor = UIColor(red: 18/255, green: 23/255, blue: 38/255, alpha: 1)
		self.scrollView.backgroundColor = backColor
		self.addSubview(self.scrollView)
		
		createContentViews(navigationController)
		
		self.square1.backgroundColor = UIColor.redColor()
		self.square2.backgroundColor = UIColor.blueColor()
		self.square3.backgroundColor = UIColor.blueColor()
		self.square4.backgroundColor = UIColor.blueColor()
		
		self.addSubview(self.square1)
		self.addSubview(self.square2)
		self.addSubview(self.square3)
		self.addSubview(self.square4)
		
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		
		let pageWidth = scrollView.frame.size.width;
		let fractionalPage = scrollView.contentOffset.x / pageWidth;
		let page = Int(ceil(fractionalPage));
		if (self.previousPage != page) {
			
			self.square1.backgroundColor = UIColor.blueColor()
			self.square2.backgroundColor = UIColor.blueColor()
			self.square3.backgroundColor = UIColor.blueColor()
			self.square4.backgroundColor = UIColor.blueColor()
			
			switch page {
			case 0:
				self.square1.backgroundColor = UIColor.redColor()
			case 1:
				self.square2.backgroundColor = UIColor.redColor()
			case 2:
				self.square3.backgroundColor = UIColor.redColor()
			case 3:
				self.square4.backgroundColor = UIColor.redColor()
			default:
				self.square1.backgroundColor = UIColor.blueColor()
			}
			self.previousPage = page;
		}
	}
	
	func createContentViews(navigationController:UINavigationController){
		var xPosition = CGFloat(0)
		
		for content in tutorialContent {
			let pageVC = PageView(frame: frame, content: content, navigationController: navigationController)
			
			pageVC.frame = CGRectMake(xPosition, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
			self.scrollView.addSubview(pageVC)
			pageVC.btn.addTarget(self, action: "buttonTouched", forControlEvents:UIControlEvents.TouchUpInside)
			
			xPosition += UIScreen.mainScreen().bounds.width
		}
		
		let totemView = nameView(frame: frame, navigationController: navigationController)
		
		totemView.frame = CGRectMake(xPosition, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
		self.scrollView.addSubview(totemView)
		totemView.btn.addTarget(self, action: "nameCompleted", forControlEvents:UIControlEvents.TouchUpInside)
		
		xPosition += UIScreen.mainScreen().bounds.width
		
		self.scrollView.contentSize = CGSizeMake(xPosition, 0)
		self.scrollView.pagingEnabled = true
	}
	
	func nameCompleted() {
		NSNotificationCenter.defaultCenter().postNotificationName("tutorialComplete", object: self)
		
		// Notification uitsturen om de data te herladen op de badges pagina
		NSNotificationCenter.defaultCenter().postNotificationName("UserSet", object: self)
	}
	
	func buttonTouched() {
		let scrollPoint = CGPointMake((self.scrollView.contentOffset.x + UIScreen.mainScreen().bounds.width), self.scrollView.contentOffset.y)
		
		self.scrollView.setContentOffset(scrollPoint, animated: true)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


}
