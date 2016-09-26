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
		let controller1 = storyboard.instantiateViewController(withIdentifier: "firstView")
		let controller2 = storyboard.instantiateViewController(withIdentifier: "secondView")
		let controller3 = storyboard.instantiateViewController(withIdentifier: "thirdView")
		let controller4 = storyboard.instantiateViewController(withIdentifier: "tableView")
		let controller5 = storyboard.instantiateViewController(withIdentifier: "fifthView")
		let controller6 = storyboard.instantiateViewController(withIdentifier: "sixthView")

		// Setting up the PagerController with Name of the Tabs and their respective ViewControllers
		self.setupPager(
			tabNames: ["Blue", "Orange", "Light Blue", "Grey", "Purple", "Green"],
			tabControllers: [controller1, controller2, controller3, controller4, controller5, controller6])

		customizeTab()

		if let controller = controller4 as? GreyViewController {
			controller.didSelectRow = pushGreyDetailViewController
		}
	}

	// Customising the Tab's View
	func customizeTab() {
		indicatorColor = UIColor.white
		tabsViewBackgroundColor = UIColor(rgb: 0x00AA00)
		contentViewBackgroundColor = UIColor.gray.withAlphaComponent(0.32)

		startFromSecondTab = false
		centerCurrentTab = true
		tabLocation = PagerTabLocation.top
		tabHeight = 49
		tabOffset = 36
		tabWidth = 96.0
		fixFormerTabsPositions = false
		fixLaterTabsPosition = false
        animation = PagerAnimation.during
        selectedTabTextColor = .blue
        tabsTextFont = UIFont(name: "HelveticaNeue-Bold", size: 20)!
        // tabTopOffset = 10.0
        // tabsTextColor = .purpleColor()

	}


	// Programatically selecting a tab. This function is getting called on AppDelegate
	func changeTab() {
		self.selectTabAtIndex(4)
	}


	func pushGreyDetailViewController(text: String) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let detail = storyboard.instantiateViewController(withIdentifier: "greyTableDetail") as? GreyDetailViewController {
			detail.text = text
			self.navigationController?.pushViewController(detail, animated: true)
		}
	}


}
