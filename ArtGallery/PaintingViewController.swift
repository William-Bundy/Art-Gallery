//
//  ViewController.swift
//  ArtGallery
//
//  Created by Spencer Curtis on 7/20/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class PaintingListView: UIViewController
{
	@IBOutlet weak var table: UITableView!
	var source:PaintingSource
	
	required init?(coder aDecoder: NSCoder) {
		source = PaintingSource(AppGlobal.paintingController)
		super.init(coder:aDecoder);
	}
	
	override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
		guard table != nil else {return}
		source.table = table
		table.dataSource = source
		table.delegate = source
		table.reloadData()
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PaintingSegue" {
			let dest = segue.destination as? PaintingFullscreenView
			let painting = sender as? PaintingCell
			dest?.painting = painting?.painting
		}
	}
}

class PaintingFullscreenView: UIViewController
{
	var painting:Painting!
	@IBOutlet weak var paintingView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		guard painting != nil, paintingView != nil else {return}
		paintingView.image = painting.image
		let bounds:(frame:CGRect, center:CGPoint) = painting.image.getScreenSize(padding:DefaultPadding, scale:1)
		paintingView.frame = bounds.frame
		paintingView.center = bounds.center
		paintingView.center.y += 60
	}
	
	@IBAction func donePressed(_ sender: Any) {
		dismiss(animated: true, completion: {() in})
	}
	
}

