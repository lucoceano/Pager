//
//  ViewController.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import UIKit

class ViewController: PagerController, PagerDataSource {

	var titles: [String] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self

		// Instantiating Storyboard ViewControllers
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller1 = storyboard.instantiateViewControllerWithIdentifier("firstView")
		let controller2 = storyboard.instantiateViewControllerWithIdentifier("secondView")
		let controller3 = storyboard.instantiateViewControllerWithIdentifier("thirdView")
		let controller4 = storyboard.instantiateViewControllerWithIdentifier("fourthView")
		let controller5 = storyboard.instantiateViewControllerWithIdentifier("fifthView")
		let controller6 = storyboard.instantiateViewControllerWithIdentifier("sixthView")

		// Setting up the PagerController with Name of the Tabs and their respective ViewControllers
		self.setupPager(
			tabNames: ["Blue", "Orange", "Light Blue", "Grey", "Purple", "Green"],
			tabControllers: [controller1, controller2, controller3, controller4, controller5, controller6])

		customiseTab()
	}

	// Customising the Tab's View
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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// Programatically selecting a tab. This function is getting called on AppDelegate
	func changeTab() {
		self.selectTabAtIndex(4)
	}
}
