//
//  Image.swift
//  ArtGallery
//
//  Created by William Bundy on 7/25/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import Foundation
import UIKit

struct Painting
{
	var image:UIImage!
	var isLiked:Bool
}

class PaintingController
{
	var paintings:[Painting] = []
	
	func constructPaintings()
	{
		if paintings.count > 0 {return}
		for i in 0..<12 {
			let painting = Painting(image:UIImage(named:"Image\(i+1)"), isLiked:false)
			paintings.append(painting)
		}
	}
}

