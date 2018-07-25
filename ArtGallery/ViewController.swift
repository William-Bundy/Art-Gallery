//
//  ViewController.swift
//  ArtGallery
//
//  Created by Spencer Curtis on 7/20/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

protocol PaintingCellDelegate: class {
	func onLike(_ cell: PaintingCell)
}

let DefaultPadding:CGFloat = 32
let HalfPadding:CGFloat = DefaultPadding / 2

extension UIImage {
	func  getScreenSize(padding:CGFloat, scale:CGFloat=0.5) -> (frame: CGRect, center:CGPoint)
	{
		let hpadding = padding / 2
		let totalWidth = UIScreen.main.bounds.width
		let sw = totalWidth * scale - padding
		let ratio = sw / size.width
		let finalWidth = sw
		let finalHeight = ratio * size.height
		return  (CGRect(x:0, y:0, width:finalWidth, height:finalHeight), CGPoint(x:totalWidth/2, y:finalHeight/2 + hpadding))
	}
}
class PaintingCell: UITableViewCell
{
	var index:Int = 0
	var painting:Painting! {
		didSet {
			updateViews()
		}
	}
	weak var delegate:PaintingCellDelegate!
	@IBOutlet weak var likeButton: UIButton!
	@IBOutlet weak var paintingView: UIImageView!
	
	func updateViews()
	{
		paintingView.image = painting.image
		let bounds:(frame:CGRect, center:CGPoint) = painting.image.getScreenSize(padding:DefaultPadding)
		paintingView.frame = bounds.frame
		paintingView.center = bounds.center

		likeButton.setTitle(painting.isLiked ? "Unlike" : "Like", for:UIControlState.normal)
		likeButton.center = CGPoint(x:bounds.center.x, y: bounds.center.y + bounds.frame.height/2 + likeButton.frame.height/2 + HalfPadding)
	}

	@IBAction func likeButtonPressed(_ sender: Any) {
		// update the local copy, just in case
		painting.isLiked = !painting.isLiked
		delegate?.onLike(self)
	}
}

class PaintingSource: NSObject, UITableViewDataSource, UITableViewDelegate, PaintingCellDelegate
	
{
	var controller:PaintingController!
	var table:UITableView!

	required init(_ controller:PaintingController)
	{
		self.controller = controller
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		let defaultCell = tableView.dequeueReusableCell(withIdentifier: "PaintingCell")
		guard let cell = defaultCell as? PaintingCell else { return defaultCell! }
		cell.delegate = self
		cell.painting = controller.paintings[indexPath.row]
		cell.index = indexPath.row
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
	{
		return controller.paintings[indexPath.row].image.getScreenSize(padding: 32).0.height + 80
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return controller.paintings.count
	}
	
	func onLike(_ cell: PaintingCell)
	{
		let liked = controller.paintings[cell.index].isLiked
		controller.paintings[cell.index].isLiked = !liked
		UIView.setAnimationsEnabled(false)
		table.reloadRows(at:[IndexPath(row:cell.index, section:0)], with:.none)
		UIView.setAnimationsEnabled(true)
	}

}


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

