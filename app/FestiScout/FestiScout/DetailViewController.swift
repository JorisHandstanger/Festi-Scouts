//
//  DetailViewController.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 13/06/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
	
	var badgeData:BadgeData
	
	init( badgedata:BadgeData) {
		self.badgeData = badgedata
		super.init(nibName: nil, bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func popToRoot(sender:UIBarButtonItem){
		self.navigationController!.popToRootViewControllerAnimated(true)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let badgecount = self.navigationController?.navigationBar.subviews.filter { ($0 as! UIView).frame == CGRectMake(0, 0, 49, 44) }
		let result = badgecount?.first as! UIView
		result.alpha = 0
		
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
		
		let bgImageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		let bgImage = UIImage(named: "background2")
		bgImageView.image = bgImage
		self.view.addSubview(bgImageView)
		
		let badgeImageView = UIImageView(frame: CGRectMake(40, 84, (UIScreen.mainScreen().bounds.width - 80), (UIScreen.mainScreen().bounds.width - 80)))
		let badgeImage = UIImage(named: badgeData.image)
		
		// Tekstballon
		let tbImageView = UIImageView(frame: CGRectMake(12, 305, 298, 228))
		let tbImage = UIImage(named: "tekstballon")
		tbImageView.image = tbImage
		self.view.addSubview(tbImageView)
		
		
		if(badgeData.done) {
			// Challenge is gedaan
			badgeImageView.image = badgeImage
			self.view.addSubview(badgeImageView)
			
			let resultaatImageView = UIImageView(frame: CGRectMake(30, 368, 111, 43))
			let resultaatImage = UIImage(named: "resultaat")
			resultaatImageView.image = resultaatImage
			self.view.addSubview(resultaatImageView)
			
		}else {
			// Challenge nog niet gedaan
			let image = CIImage(image: badgeImage)
			let context = CIContext(options: nil)
			let filter = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputImageKey : image, kCIInputBrightnessKey : NSNumber(double: -0.2), kCIInputSaturationKey : NSNumber(double: 0.3)])
			let result = filter.outputImage
			
			badgeImageView.image = UIImage(CIImage: result)
			badgeImageView.alpha = 0.5
			self.view.addSubview(badgeImageView)
			
			if(badgeData.interactable){
				// Start button
				let btnStart = UIButton(frame: CGRectMake(33, 220, 254, 113))
				btnStart.setBackgroundImage(UIImage(named: "startButton"), forState: UIControlState.Normal)
				btnStart.addTarget(self, action: "startChallenge:", forControlEvents: .TouchUpInside)
				self.view.addSubview(btnStart)
			}
			
			//tijd
			let lblTijd = UILabel(frame: CGRectMake(68, 370, 85, 40))
			lblTijd.text = "= " + String(badgeData.tijd) + " min"
			lblTijd.textColor = UIColor(red:224/255, green:85/255,blue:53/255,alpha:1.0)
			lblTijd.textAlignment = NSTextAlignment.Center
			lblTijd.font = UIFont(name: "MAXWELLBOLD", size: 25)
			self.view.addSubview(lblTijd)
			
			let klokImageView = UIImageView(frame: CGRectMake(25, 370, 40, 40))
			let klokImage = UIImage(named: "klok")
			klokImageView.image = klokImage
			self.view.addSubview(klokImageView)
		}
		
		//Plezier meter
		for i in 0 ... (badgeData.plezier - 1) {
			var xpos:CGFloat = 177 + (CGFloat(i) * 24)
			let plezierImageView = UIImageView(frame: CGRectMake(xpos, 367, 22, 22))
			let plezierImage = UIImage(named: "smiley")
			plezierImageView.image = plezierImage
			self.view.addSubview(plezierImageView)
		}
		
		for i in badgeData.plezier ... 4 {
			var xpos:CGFloat = 177 + (CGFloat(i) * 24)
			let plezierImageView = UIImageView(frame: CGRectMake(xpos, 367, 22, 22))
			let plezierImage = UIImage(named: "smiley")
			plezierImageView.image = plezierImage
			
			plezierImageView.image = plezierImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
			plezierImageView.tintColor = UIColor(red:203/255, green:196/255,blue:111/255,alpha:1.0)
			
			plezierImageView.alpha = 0.4
			self.view.addSubview(plezierImageView)
		}
		
		//Peer plezier meter
		println(badgeData.plezier)
		for i in 0 ... (badgeData.peerPlezier - 1) {
			var xpos:CGFloat = 177 + (CGFloat(i) * 24)
			let friendsImageView = UIImageView(frame: CGRectMake(xpos, 398, 22, 15))
			let friendsImage = UIImage(named: "friends")
			friendsImageView.image = friendsImage
			self.view.addSubview(friendsImageView)
		}

		for i in badgeData.peerPlezier ... 4 {
			var xpos:CGFloat = 177 + (CGFloat(i) * 24)
			let friendsImageView = UIImageView(frame: CGRectMake(xpos, 398, 22, 15))
			let friendsImage = UIImage(named: "friends")
			friendsImageView.image = friendsImage
			
			friendsImageView.image = friendsImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
			friendsImageView.tintColor = UIColor(red:203/255, green:196/255,blue:111/255,alpha:1.0)
			
			friendsImageView.alpha = 0.4
			self.view.addSubview(friendsImageView)
		}
		
		let desclbl = UITextView(frame: CGRectMake(22, 425, UIScreen.mainScreen().bounds.width - 44, 100))
		desclbl.backgroundColor = UIColor.clearColor()
		desclbl.text = badgeData.desc
		desclbl.textColor = UIColor(red:80/255, green:87/255,blue:57/255,alpha:1.0)
		desclbl.editable = false
		
		desclbl.textAlignment = NSTextAlignment.Center
		desclbl.font = UIFont(name: "Bariol-Regular", size: 16)
		
		self.view.addSubview(desclbl)
		
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func startChallenge(sender: UIButton!) {
		let challengeVC = ChallengeViewController(badgedata: self.badgeData)
		self.navigationController?.pushViewController(challengeVC, animated: true)
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
