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
	var rangview = UIImageView(frame: CGRectMake(20, 8, 20, 20))
	let lblTotem:UILabel = UILabel(frame: CGRectMake(50, 3, 230, 35))
	let lblTitel:UILabel = UILabel(frame: CGRectMake(20, 0, 230, 35))
	let lbldebadges = UILabel(frame: CGRectMake(200, 142, 100, 30))
	
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
		
		let rang:String =  NSUserDefaults.standardUserDefaults().stringForKey("rang")!
		
		switch rang {
			case "groentje":
			self.rangview.image = UIImage(named: "icon_groentje")
			case "lid":
			self.rangview.image = UIImage(named: "icon_lid")
			case "leiding":
			self.rangview.image = UIImage(named: "icon_leiding")
			default:
			self.rangview.image = UIImage(named: "icon_groentje")
		}
		cardHeader.addSubview(self.rangview)
		
		// Content lidkaart
		let bn = NSUserDefaults.standardUserDefaults().stringForKey("userBackImage")
		let animal = NSUserDefaults.standardUserDefaults().stringForKey("userFrontImage")
		
		let bnView = UIImageView(image: UIImage(named: bn!))
		bnView.frame = CGRectMake(20, 55, 110, 110)
		bnView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(bnView)
		
		let animalView = UIImageView(image: UIImage(named: animal!))
		animalView.frame = CGRectMake(20, 55, 110, 110)
		animalView.contentMode = UIViewContentMode.ScaleAspectFit
		self.addSubview(animalView)
		
		let lblNaam = UILabel(frame: CGRectMake(140, 50, 100, 30))
		lblNaam.text =	"Totem:"
		lblNaam.textColor = UIColor(red:195/255, green:186/255,blue:88/255,alpha:1.0)
		lblNaam.font = UIFont(name: "BigNoodleTitling", size: 23)
		self.addSubview(lblNaam)
		
		let lblDeNaam = UILabel(frame: CGRectMake(150, 75, 160, 30))
		lblDeNaam.text = NSUserDefaults.standardUserDefaults().stringForKey("userTotem")
		lblDeNaam.adjustsFontSizeToFitWidth = true
		lblDeNaam.textColor = UIColor(red:249/255, green:233/255,blue:202/255,alpha:1.0)
		lblDeNaam.font = UIFont(name: "brooklyncofferegular", size: 16)
		self.addSubview(lblDeNaam)
		
		let lblrang = UILabel(frame: CGRectMake(140, 95, 100, 30))
		lblrang.text =	"Rang:"
		lblrang.textColor = UIColor(red:195/255, green:186/255,blue:88/255,alpha:1.0)
		lblrang.font = UIFont(name: "BigNoodleTitling", size: 23)
		self.addSubview(lblrang)
		
		let lblDeRang = UILabel(frame: CGRectMake(170, 120, 140, 30))
		lblDeRang.text = NSUserDefaults.standardUserDefaults().stringForKey("rang")
		lblDeRang.adjustsFontSizeToFitWidth = true
		lblDeRang.textColor = UIColor(red:249/255, green:233/255,blue:202/255,alpha:1.0)
		lblDeRang.font = UIFont(name: "brooklyncofferegular", size: 16)
		self.addSubview(lblDeRang)
		
		var rangcview = UIImageView(frame: CGRectMake(150, 125, 15, 15))
		switch NSUserDefaults.standardUserDefaults().stringForKey("rang")! {
			case "groentje":
				rangcview.image = UIImage(named: "icon_groentje")
			case "lid":
				rangcview.image = UIImage(named: "icon_lid")
			case "leiding":
				rangcview.image = UIImage(named: "icon_leiding")
			default:
				rangcview.image = UIImage(named: "icon_groentje")
		}
		self.addSubview(rangcview)
		
		let lblbadges = UILabel(frame: CGRectMake(140, 140, 100, 30))
		lblbadges.text =	"Badges:"
		lblbadges.textColor = UIColor(red:195/255, green:186/255,blue:88/255,alpha:1.0)
		lblbadges.font = UIFont(name: "BigNoodleTitling", size: 23)
		self.addSubview(lblbadges)
		
		self.lbldebadges.textColor = UIColor(red:249/255, green:233/255,blue:202/255,alpha:1.0)
		self.lbldebadges.font = UIFont(name: "brooklyncofferegular", size: 23)
		self.addSubview(self.lbldebadges)
		
		let lblnummer = UILabel(frame: CGRectMake(20, 175, 220, 30))
		lblnummer.text = "1 2 0 2 1 9 9 4   1 4 0   8 9 5"
		lblnummer.textColor = UIColor(red:249/255, green:233/255,blue:202/255,alpha:1.0)
		lblnummer.font = UIFont(name: "brooklyncofferegular", size: 20)
		self.addSubview(lblnummer)
		
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
