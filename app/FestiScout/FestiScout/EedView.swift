//
//  EedView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 16/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import Alamofire

class EedView: UIView {

	var navC:UINavigationController
	let steponeView = UIImageView(frame: CGRectMake(0, 0, 320, 474))
	let balloon = UIImageView(frame: CGRectMake(0, 0, 320, 474))
	var APIUrls : NSDictionary = NSDictionary()
	
	init(frame: CGRect, navigationController:UINavigationController, urls:NSDictionary) {
		self.navC = navigationController
		
		super.init(frame: frame)
		self.APIUrls = urls
		
		let bgView = UIImageView(image: UIImage(named: "eedback"))
		bgView.frame = CGRectMake(0, 0, 320, 474)
		bgView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(bgView)
		
		self.stap1()
		
		UIView.animateWithDuration(0.5, animations: {
			self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - 474, 320, 474)
		})
	}
	
	func stap1() {
		
		self.steponeView.image = UIImage(named: "stap1")
		self.steponeView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(self.steponeView)
		
		let btnStart = UIButton(frame: CGRectMake(40, 370, 235, 58))
		btnStart.setBackgroundImage(UIImage(named: "eed-afleggen-btn"), forState: UIControlState.Normal)
		btnStart.addTarget(self, action: "stap2:", forControlEvents: .TouchUpInside)
		self.addSubview(btnStart)
	}
	
	func stap2(sender: UIButton!) {
		UIView.animateWithDuration(0.5, animations: {
			self.steponeView.image = UIImage(named: "stap2")
			sender.removeFromSuperview()
		})
		
		self.balloon.image = UIImage(named: "eedtekstballon")
		self.addSubview(self.balloon)
		
		let btntetjes = UIButton(frame: CGRectMake(33,self.frame.height - 120, 235, 120))
		btntetjes.setBackgroundImage(UIImage(named: "tetjes"), forState: UIControlState.Normal)
		btntetjes.addTarget(self, action: "removeBallon:", forControlEvents: .TouchDown)
		btntetjes.addTarget(self, action: "stap3:", forControlEvents: .TouchUpInside)
		self.addSubview(btntetjes)
	}
	
	func stap3(sender: UIButton!) {
		UIView.animateWithDuration(0.5, animations: {
			self.steponeView.image = UIImage(named: "stap3")
			sender.removeFromSuperview()
		})
		
		let btnZegel = UIButton(frame: CGRectMake((self.frame.width/2)-44,315, 86, 86))
		btnZegel.setBackgroundImage(UIImage(named: "zegel"), forState: UIControlState.Normal)
		btnZegel.addTarget(self, action: "enveloppe:", forControlEvents: .TouchUpInside)
		self.addSubview(btnZegel)
	}
	
	func enveloppe(sender: UIButton!) {
		let enveloppeView = UIImageView(frame: CGRectMake(0, 0, 320, 474))
		enveloppeView.image = UIImage(named: "eedresult")
		enveloppeView.contentMode = UIViewContentMode.ScaleAspectFit
		enveloppeView.alpha = 0.0
		self.addSubview(enveloppeView)
		
		let btnExit = UIButton(frame: CGRectMake((self.frame.width/2)-20,300, 70, 70))
		btnExit.setBackgroundImage(UIImage(named: "slide-down"), forState: UIControlState.Normal)
		btnExit.addTarget(self, action: "stop:", forControlEvents: .TouchUpInside)
		self.addSubview(btnExit)
		
		UIView.animateWithDuration(0.5, animations: {
			enveloppeView.alpha = 1.0
		})
	}
	
	func stop(sender: UIButton!) {
		UIView.animateWithDuration(0.5, animations: {
			self.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height, 320, 474)
			self.alpha = 0.0
		})
		
		let data = [
			"userId": String(NSUserDefaults.standardUserDefaults().integerForKey("userId")),
			"badgeId": "3",
			"image": ""
		]
		
		Alamofire.request(.POST, self.APIUrls["completed"]! as! String, parameters: data).responseJSON{(_, _, data, _) in
			
			NSUserDefaults.standardUserDefaults().setObject("leiding", forKey: "rang")
			NSNotificationCenter.defaultCenter().postNotificationName("reload", object: self)
			
		}
		
	}
	
	func removeBallon(sender: UIButton!) {
		UIView.animateWithDuration(0.5, animations: {
			self.balloon.alpha = 0.0
		})
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
