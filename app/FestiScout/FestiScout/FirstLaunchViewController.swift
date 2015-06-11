//
//  FirstLaunchViewController.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 28/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FirstLaunchMainViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		self.getTotem();
		self.navigationController?.navigationBarHidden = true
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "popController", name: "tutorialComplete", object: nil)
		
	}
	
	func popController(){
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
	
	override func loadView() {
		println("[ViewController] Loading slider view")
		var bounds = UIScreen.mainScreen().bounds
		self.view = TutorialView(frame: bounds, navigationController: self.navigationController!)
		
	}
	
	func getTotem(){
		let totemRequest = Alamofire.request(.GET, "http://192.168.1.147/FestiScouts/api/getTotem")
		totemRequest.responseJSON{(_, _, data, _) in
			
			// Via de api een willekeurige naam krijgen en checken of deze al in gebruik is
			
			var json = JSON(data!)
			var karakter:String = json.arrayValue[0]["Totem"].stringValue
			var dier:String = json.arrayValue[1]["Totem"].stringValue
			var totem:String = karakter + " " + dier
			var totemQuery:String = totem.stringByReplacingOccurrencesOfString(" ", withString: "%20")
			
			let totemCheckRequest = Alamofire.request(.GET, "http://192.168.1.147/FestiScouts/api/users/" + totemQuery)
			totemCheckRequest.responseJSON{(_, _, data, _) in
				if((data) != nil){
					if(data! === true){
						self.getTotem()
					}else{
						self.createUser(totem, karakter: karakter, dier: dier)
					}
				}
			}
		}
	}
	
	func createUser(totem:String, karakter:String, dier:String){
		var karakterImage:String = karakter.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png"
		var dierImage:String = dier.stringByReplacingOccurrencesOfString(" ", withString: "") + ".png"
		println("Jouw totem: " + totem)
		
		let data = [
			"totem": totem,
			"animalImage": dierImage,
			"backImage": karakterImage
		]
		
		Alamofire.request(.POST, "http://192.168.1.147/FestiScouts/api/users/", parameters: data).responseJSON{(_, _, data, _) in
			
			// Return data van insert opslaan als userdefaults
			
			var json = JSON(data!)
			
			var userId:Int = json["id"].intValue
			var userTotem:NSString = json["totem"].stringValue
			var userFrontImage:NSString = json["animalImage"].stringValue
			var userBackImage:NSString = json["backImage"].stringValue
			
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "userSaved")
			NSUserDefaults.standardUserDefaults().setInteger(userId, forKey: "userId")
			NSUserDefaults.standardUserDefaults().setObject(userTotem, forKey: "userTotem")
			NSUserDefaults.standardUserDefaults().setObject(userFrontImage, forKey: "userFrontImage")
			NSUserDefaults.standardUserDefaults().setObject(userBackImage, forKey: "userBackImage")
			NSUserDefaults.standardUserDefaults().synchronize()
			
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

