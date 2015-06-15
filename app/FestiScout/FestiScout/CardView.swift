//
//  CardView.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 31/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class CardView: UIView {
	
	
	var opened:Bool = false
	var pijltjeview = UIImageView(image: UIImage(named: "pijltje"))
	var rangview = UIImageView(image: UIImage(named: "icon_groentje"))
	let lblTotem:UILabel = UILabel(frame: CGRectMake(50, 3, 230, 35))
	let lblTitel:UILabel = UILabel(frame: CGRectMake(20, 0, 230, 35))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = UIColor.clearColor()
		
		// Background
		let backImageView:UIImageView
		let backImage = UIImage(named: "cardBack")
		backImageView = UIImageView(image: backImage)
		self.addSubview(backImageView)
		
		// Bovenkant lidkaart
		let	cardHeader = UIView(frame: CGRectMake(0, 0, frame.width, 32))
		cardHeader.backgroundColor = UIColor.clearColor()
		self.addSubview(cardHeader)
	
		self.lblTotem.text = NSUserDefaults.standardUserDefaults().stringForKey("userTotem")
		self.lblTotem.adjustsFontSizeToFitWidth = true
		self.lblTotem.textColor = UIColor.whiteColor()
		self.lblTotem.font = UIFont(name: "brooklyncofferegular", size: 21)
		cardHeader.addSubview(self.lblTotem)
		
		
		self.lblTitel.text =	"lidkaart festi-scout"
		self.lblTitel.textColor = UIColor(red:138/255, green:156/255,blue:96/255,alpha:1.0)
		self.lblTitel.font = UIFont(name: "BigNoodleTitling", size: 25)
		self.lblTitel.alpha = 0
		cardHeader.addSubview(self.lblTitel)
		
		self.pijltjeview.frame = CGRectMake(280, 8, self.pijltjeview.frame.size.width, self.pijltjeview.frame.size.height)
		cardHeader.addSubview(self.pijltjeview)
		
		self.rangview.frame = CGRectMake(20, 8, self.pijltjeview.frame.size.width, self.pijltjeview.frame.size.height)
		cardHeader.addSubview(self.rangview)
		
		// Content lidkaart
		let lblNaam = UILabel(frame: CGRectMake(20, 50, 100, 32))
		lblNaam.text =	"Totem:"
		lblNaam.textColor = UIColor(red:249/255, green:233/255,blue:202/255,alpha:1.0)
		lblNaam.font = UIFont(name: "brooklyncofferegular", size: 21)
		self.addSubview(lblNaam)
		
		let lblDeNaam = UILabel(frame: CGRectMake(20, 80, 250, 30))
		lblDeNaam.text = NSUserDefaults.standardUserDefaults().stringForKey("userTotem")
		lblDeNaam.adjustsFontSizeToFitWidth = true
		lblDeNaam.textColor = UIColor(red:249/255, green:233/255,blue:202/255,alpha:1.0)
		lblDeNaam.font = UIFont(name: "Bearandloupe", size: 21)
		self.addSubview(lblDeNaam)
		
		// Open en sluit
		self.transform = CGAffineTransformIdentity;
		let tap = UITapGestureRecognizer(target: self, action: "touched:")
		cardHeader.addGestureRecognizer(tap)
	}
	
	/*func enumerateFonts(){
		for fontFamily in UIFont.familyNames() {
			println("Font family name = \(fontFamily as! String)");
			
			for fontName in UIFont.fontNamesForFamilyName(fontFamily as! String){
				println("- Font name = \(fontName)");
			}
			
			println("\n")
		}
	}*/
	
	func touched(sender:UITapGestureRecognizer) {
		if(!self.opened){
			UIView.animateWithDuration(0.3, animations: {
				self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-200, self.frame.width, self.frame.height)
				let t = CGAffineTransformMakeRotation(-0.14);
				self.transform = t
				let u = CGAffineTransformMakeRotation(3.14);
				self.pijltjeview.transform = u
				self.lblTotem.alpha = 0
				self.rangview.alpha = 0
				self.lblTitel.alpha = 1
			})
			self.opened = true
		}else{
			self.closeCard()
		}
	}
	
	func closeCard(){
		UIView.animateWithDuration(0.3, animations: {
			self.transform = CGAffineTransformIdentity;
			self.pijltjeview.transform = CGAffineTransformIdentity;
			self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+200, self.frame.width, self.frame.height)
			self.lblTotem.alpha = 1
			self.rangview.alpha = 1
			self.lblTitel.alpha = 0
		})
		self.opened = false
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

}
