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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let bgImageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
		let bgImage = UIImage(named: "background2")
		bgImageView.image = bgImage
		self.view.addSubview(bgImageView)
		
		
		// GEDAAN
		let badgeImageView = UIImageView(frame: CGRectMake(40, 84, (UIScreen.mainScreen().bounds.width - 80), (UIScreen.mainScreen().bounds.width - 80)))
		let badgeImage = UIImage(named: badgeData.image)
		
		let image = CIImage(image: badgeImage)
		let context = CIContext(options: nil)
		let filter = CIFilter(name: "CIColorControls", withInputParameters: [kCIInputImageKey : image, kCIInputBrightnessKey : NSNumber(double: -0.2), kCIInputSaturationKey : NSNumber(double: 0.3)])
		let result = filter.outputImage
		
		badgeImageView.image = UIImage(CIImage: result)
		badgeImageView.alpha = 0.5
		self.view.addSubview(badgeImageView)
		
		// NOG NIET GEDAAN
		
		let btnStart = UIButton(frame: CGRectMake(33, 220, 254, 113))
		btnStart.setBackgroundImage(UIImage(named: "startButton"), forState: UIControlState.Normal)
		btnStart.addTarget(self, action: "startChallenge:", forControlEvents: .TouchUpInside)
		self.view.addSubview(btnStart)
		
		let tbImageView = UIImageView(frame: CGRectMake(12, 305, 298, 228))
		let tbImage = UIImage(named: "tekstballon")
		tbImageView.image = tbImage
		self.view.addSubview(tbImageView)
		
		let desclbl = UITextView(frame: CGRectMake(30, 425, UIScreen.mainScreen().bounds.width - 60, 100))
		desclbl.backgroundColor = UIColor.clearColor()
		desclbl.text = badgeData.desc
		desclbl.editable = false
		
		desclbl.textAlignment = NSTextAlignment.Center
		desclbl.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
		
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
