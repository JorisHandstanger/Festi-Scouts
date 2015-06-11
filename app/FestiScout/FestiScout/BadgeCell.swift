//
//  BadgeCollectionViewCell.swift
//  FestiScouts
//
//  Created by Joris Handstanger on 30/05/15.
//  Copyright (c) 2015 Joris Handstanger. All rights reserved.
//

import UIKit

class BadgeCell: UICollectionViewCell {
	
	var textLabel:UILabel!
	var imageView:UIImageView!
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override init(frame: CGRect) {
		
		super.init(frame: frame)
		
		contentView.backgroundColor = UIColor.clearColor()
		// ImageView voor de badge
		imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width-10, height: frame.size.width-10))
		imageView.contentMode = UIViewContentMode.ScaleAspectFit
		contentView.addSubview(imageView)
		
		// Label voor titel onder badge
		let textFrame = CGRect(x: 0, y: imageView.frame.size.height, width: frame.size.width, height: frame.size.height/4)
		textLabel = UILabel(frame: textFrame)
		textLabel.lineBreakMode = .ByWordWrapping
		textLabel.numberOfLines = 0
		textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
		textLabel.textAlignment = .Center
		contentView.addSubview(textLabel)
	}

	
}
