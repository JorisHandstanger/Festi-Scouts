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
	
	var circles: [UIImageView] = []
	
	init(frame: CGRect, navigationController:UINavigationController) {
		
		let p1 = contentData(picture: "tutWelkom", info: "lorem ipsum")
		let p2 = contentData(picture: "tutBadges", info: "lorem ipsum")
		let p3 = contentData(picture: "rangen",
			info: "zoals iedere goede dictatuur zijn er rangen. Je begint als groentje maar na 5 badges ben je al volwaardig lid. Het doel is natuurlijk om leiding te worden en dit kan je pas worden na 15 badges verzameld te hebben. ")
		let p4 = contentData(picture: "leidingWorden", info: "lorem ipsum")
		
		self.tutorialContent = [p1, p2, p3, p4]
		
		self.scrollView = UIScrollView(frame: frame)
		super.init(frame: frame)
		
		self.scrollView.delegate = self
		
		self.backgroundColor = UIColor.whiteColor()
		
		let bgImageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		let bgImage = UIImage(named: "background2")
		bgImageView.image = bgImage
		self.addSubview(bgImageView)
		
		self.scrollView.backgroundColor = UIColor.clearColor()
		self.addSubview(self.scrollView)
		
		createContentViews(navigationController)
		
		for i in 0 ... 4 {
			let circleView = UIImageView(frame: CGRectMake(CGFloat(90 + (28 * i)), 500, 23, 24))
			circleView.image = UIImage(named: "circle")
			circleView.image = circleView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
			if i == 0 {
				circleView.tintColor = UIColor(red: 69/255, green: 78/255, blue: 48/255, alpha: 1.0)
			}else{
				circleView.tintColor = UIColor(red: 149/255, green: 141/255, blue: 57/255, alpha: 1.0)
			}
			circles.append(circleView)
			self.addSubview(circleView)
		}
		
	}

	func scrollViewDidScroll(scrollView: UIScrollView) {
		
		let pageWidth = scrollView.frame.size.width;
		let fractionalPage = scrollView.contentOffset.x / pageWidth;
		let page = Int(floor(fractionalPage));
		if (self.previousPage != page) {
			
			for i in 0 ... 4 {
				circles[i].tintColor = UIColor(red: 149/255, green: 141/255, blue: 57/255, alpha: 1.0)
			}
			
			circles[page].tintColor = UIColor(red: 69/255, green: 78/255, blue: 48/255, alpha: 1.0)
			
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
		
		// Notification uitsturen om de data te herladen op de home pagina
		NSNotificationCenter.defaultCenter().postNotificationName("reload", object: self)
	}
	
	func buttonTouched() {
		let scrollPoint = CGPointMake((self.scrollView.contentOffset.x + UIScreen.mainScreen().bounds.width), self.scrollView.contentOffset.y)
		
		self.scrollView.setContentOffset(scrollPoint, animated: true)
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


}
