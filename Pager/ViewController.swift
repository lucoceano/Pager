//
//  ViewController.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import UIKit

class ViewController: PagerController, PagerDataSource {

	var content: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self

		self.indicatorColor = UIColor.whiteColor()
		self.tabsViewBackgroundColor = UIColor(rgb: 0x00AA00)
		self.contentViewBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.32)

		self.startFromSecondTab = false
		self.centerCurrentTab = false
		self.tabLocation = PagerTabLocation.Top
		self.tabHeight = 49
		self.tabOffset = 36
		self.tabWidth = 96.0
		self.fixFormerTabsPositions = false
		self.fixLaterTabsPosition = false
		self.animation = PagerAnimation.During

		setupPages(10)
	}

	func setupPages(count: Int)
	{
		self.content = [String](count: count, repeatedValue: "")
		for index in 0 ... count - 1 {
			print("index: \(index)")
			self.content[index] = "Tab #\(index)"
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func changeTab() {
		self.selectTabAtIndex(7)
	}

	func numberOfTabs(pager: PagerController) -> Int {
		return self.content.count;
	}

	func tabViewForIndex(index: Int, pager: PagerController) -> UIView {
		let title = self.content[index]

		let label: UILabel = UILabel()
		label.text = title;
		label.textColor = UIColor.whiteColor()
		label.font = UIFont.boldSystemFontOfSize(16.0)
		label.backgroundColor = UIColor.clearColor()
		label.sizeToFit()
		return label
	}

	func viewForTabAtIndex(index: Int, pager: PagerController) -> UIView {
		let view: UIView = UIView(frame: self.view.frame)
		view.frame = self.view.frame
		view.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))

		let label: UILabel = UILabel()
		label.text = self.content[index]
		label.textColor = UIColor.blackColor()
		label.font = UIFont.boldSystemFontOfSize(16.0)
		label.sizeToFit()
		label.center = view.center
		label.frame = CGRectMake(label.frame.origin.x, 20, label.frame.size.width, label.frame.size.height)
		view.addSubview(label)

		return view
	}
}

extension UIColor {
	convenience init(rgb: UInt) {
		self.init(
			red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgb & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0)
		)
	}
}
