//
//  MainViewController.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 29/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
	
	var lidKaart: CardView?
	var collectionView: UICollectionView?
	var BadgesArray = Array<BadgeData>()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationController?.navigationBarHidden = false
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadData", name: "UserSet", object: nil)
		
		self.automaticallyAdjustsScrollViewInsets = true
		
		let navBack = UIImage(named: "topbarback")
		self.navigationController!.navigationBar.setBackgroundImage(navBack, forBarMetrics: .Default)
		
		let logo = UIImage(named: "logo")
		let logoImageView = UIImageView(image: logo)
		logoImageView.frame.origin.y = 16
		let logoView = UIView(frame: CGRectMake(0, 0, logoImageView.frame.width, logoImageView.frame.height))
		logoView.addSubview(logoImageView)
		
		self.navigationItem.titleView = logoView
		
		// Checken of er een users in de userDefaults zit, indien niet -> nieuwe user
		
		if(!NSUserDefaults.standardUserDefaults().boolForKey("userSaved")){
			self.navigationController!.pushViewController(FirstLaunchMainViewController(), animated:false)
		}
		
		self.loadBadges()
    }
	
	func loadBadges(){
		// Badges inladen
		
		let badgesRequest = Alamofire.request(.GET, "http://192.168.1.147/FestiScouts/api/badges")
		badgesRequest.responseJSON{(_, _, data, _) in
			
			var json = JSON(data!)
			self.BadgesArray = self.createFromJSONData(json)
			
			// Maak collectionView
			
			let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
			layout.sectionInset = UIEdgeInsets(top: 100, left: 10, bottom: 30, right: 10)
			layout.itemSize = CGSize(width: (UIScreen.mainScreen().bounds.width/2)-15, height: 180)
			
			self.collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: layout)
			self.collectionView!.dataSource = self
			self.collectionView!.delegate = self
			self.collectionView!.registerClass(BadgeCell.self, forCellWithReuseIdentifier: "Cell")
			self.collectionView?.backgroundColor = UIColor.clearColor()
			
			let imageView:UIImageView
			let bckgr = UIImage(named: "background")
			imageView = UIImageView(image: bckgr)
			self.view.addSubview(imageView)
			
			self.view.addSubview(self.collectionView!)
			
			let navShadowView:UIImageView
			let shadow = UIImage(named: "topbarback")
			navShadowView = UIImageView(image: shadow)
			self.view.addSubview(navShadowView)
			
			// Maak KaartView
			let lidkaartHoogte:CGFloat = 210
			self.lidKaart = CardView(frame: CGRectMake(0, self.view.frame.height-35, self.view.frame.width, lidkaartHoogte))
			self.view.addSubview(self.lidKaart!)
			
			self.lidKaart?.layer.shadowColor = UIColor.blackColor().CGColor
			self.lidKaart?.layer.shadowOffset = CGSizeMake(10, 10)
			self.lidKaart?.layer.shadowRadius = 9
			self.lidKaart?.layer.shadowOpacity = 0.6
			
		}
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.BadgesArray.count
	}
	
	func reloadData(){
		println("reload")
		self.viewDidLoad()
		self.lidKaart?.lblTotem.text = NSUserDefaults.standardUserDefaults().stringForKey("userTotem")
	}
 
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! BadgeCell
		
		let badgeData = self.BadgesArray[indexPath.row]
		
		cell.imageView.image = UIImage(named: badgeData.image)
		cell.textLabel.text = badgeData.name
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
		
		// Bij selectie van cell doorverwijzen naar de detailpagina
		
		if(self.lidKaart!.opened){
			self.lidKaart!.closeCard()
		}
		
		let badgeData = self.BadgesArray[indexPath.row]
		let detailVC = DetailViewController(badgedata: badgeData)
		self.navigationController?.pushViewController(detailVC, animated: true)
	}
	
	func createFromJSONData(json:JSON)	-> Array<BadgeData>{
		var theArray = Array<BadgeData>()
		
		// Array maken uit JSON data
		
		for(index: String, subJson: JSON) in json {
			let id = subJson["id"]
			let name = subJson["badgeName"]
			let desc = subJson["badgeDesc"]
			let interactable = subJson["interactive"]
			let image = subJson["image"]
			let done = false
			let view = subJson["view"]
			
			let badgeData = BadgeData(id: id.intValue, name: name.stringValue, desc: desc.stringValue, interactable: interactable.boolValue, done: done, image: image.stringValue, view: view.stringValue)
			theArray.append(badgeData)
		}
		
		return theArray
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
