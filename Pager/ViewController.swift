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

		customiseTab()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller1 = storyboard.instantiateViewControllerWithIdentifier("greenVC")
    let controller2 = storyboard.instantiateViewControllerWithIdentifier("blueVC")

		titles = ["green", "blue"]
		setupPager(tabNames: titles, tabControllers: [controller1, controller2])
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

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func changeTab() {
		self.selectTabAtIndex(7)
	}
}

