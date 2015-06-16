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
	
	
	let btn = UIButton(frame: CGRectMake(55, 435, 203, 51))
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
		
		let bn = NSUserDefaults.standardUserDefaults().stringForKey("userBackImage")
		let animal = NSUserDefaults.standardUserDefaults().stringForKey("userFrontImage")

		let bnView = UIImageView(image: UIImage(named: bn!))
		bnView.frame = CGRectMake(86, 147, 145, 145)
		bnView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(bnView)
		
		let animalView = UIImageView(image: UIImage(named: animal!))
		animalView.frame = CGRectMake(86, 147, 145, 145)
		animalView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(animalView)
		
		let username = NSUserDefaults.standardUserDefaults().stringForKey("userTotem")
		
		let lblNaam = UILabel(frame: CGRectMake(50, 300, 220, 30))
		lblNaam.textAlignment = NSTextAlignment.Center
		lblNaam.text =	username
		lblNaam.adjustsFontSizeToFitWidth = true
		lblNaam.textColor = UIColor(red:69/255, green:78/255,blue:48/255,alpha:1.0)
		lblNaam.font = UIFont(name: "brooklyncofferegular", size: 21)
		self.addSubview(lblNaam)
		
		let desclbl = UITextView(frame: CGRectMake(50, 320, UIScreen.mainScreen().bounds.width - 100, 400))
		desclbl.text = "Welkom, " + username! + ", bij de festiscouts. We hebben voor jou '" + username! + "' gekozen omdat... Ik denk dat het vrij duidelijk is eigenlijk."
		desclbl.editable = false
		desclbl.textColor = UIColor(red: 69/255, green: 78/255, blue: 48/255, alpha: 1.0)
		desclbl.textAlignment = NSTextAlignment.Center
		desclbl.backgroundColor = UIColor.clearColor()
		desclbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
		self.addSubview(desclbl)
		
		self.btn.setBackgroundImage(UIImage(named: "startAdvButton"), forState: UIControlState.Normal)
		self.addSubview(self.btn)
	}
	
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
