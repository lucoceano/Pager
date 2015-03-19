//
//  ViewController.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import UIKit

class ViewController: PagerController, PagerDataSource {
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.dataSource = self

		self.indicatorColor = UIColor.redColor().colorWithAlphaComponent(0.64) //  (white: 1, alpha: 0.64)
		self.tabsViewBackgroundColor =  UIColor.grayColor().colorWithAlphaComponent(0.32)
		self.contentViewBackgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.32)
		
		self.startFromSecondTab = false
		self.centerCurrentTab = false
		self.tabLocation = PagerTabLocation.Bottom
		self.tabHeight = 49
		self.tabOffset = 36
		self.tabWidth = 96.0
		self.fixFormerTabsPositions = false
		self.fixLaterTabsPosition = false
		self.animation = PagerAnimation.End
	}

	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	
	func numberOfTabs(pager: PagerController) -> Int {
		return 10;
	}

	
	func tabViewForIndex(index: Int, pager:PagerController) -> UIView{
		var title = "Tab #\(index)"
		
		var label:UILabel = UILabel()
		label.text = title;
		label.textColor = UIColor.blackColor()
		label.sizeToFit()
		return label
	}
	
	
	func viewForTabAtIndex(index: Int, pager: PagerController) -> UIView {
		var view:UIView = UIView(frame:self.view.frame)
		view.frame = self.view.frame
		view.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(CGFloat(Float(arc4random()) / Float(UINT32_MAX)))
		
		var label:UILabel = UILabel()
		label.text  = "View #\(index)"
		label.textColor = UIColor.blackColor()
		label.sizeToFit()
		label.center = view.center
		view.addSubview(label)
		
		return view
	}
}

