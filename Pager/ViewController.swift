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

		setupPages(10)
		customiseTab()
	}

	func customiseTab()
	{
		indicatorColor = UIColor.whiteColor()
		tabsViewBackgroundColor = UIColor(rgb: 0x00AA00)
		contentViewBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.32)

		startFromSecondTab = false
		centerCurrentTab = false
		tabLocation = PagerTabLocation.Top
		tabHeight = 49
		tabOffset = 36
		tabWidth = 96.0
		fixFormerTabsPositions = false
		fixLaterTabsPosition = false
		animation = PagerAnimation.During
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

