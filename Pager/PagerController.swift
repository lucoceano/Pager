//
//  ViewPager.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import Foundation
import UIKit.UITableView

public enum PagerTabLocation: Int {
    case None = 0
    case Top = 1
    case Bottom = 2
}

public enum PagerAnimation: Int {
    case None = 0
    case End = 1
    case During = 2
}

@objc public protocol PagerDelegate: NSObjectProtocol {
    optional func didChangeTabToIndex(pager: PagerController, index: Int)
    optional func didChangeTabToIndex(pager: PagerController, index: Int, previousIndex: Int)
    optional func didChangeTabToIndex(pager: PagerController, index: Int, previousIndex: Int, swipe: Bool)
}


@objc public protocol PagerDataSource: NSObjectProtocol {
    func numberOfTabs(pager: PagerController) -> Int
    func tabViewForIndex(index: Int, pager: PagerController) -> UIView
    optional func viewForTabAtIndex(index: Int, pager: PagerController) -> UIView
    optional func controllerForTabAtIndex(index: Int, pager: PagerController) -> UIViewController
}


public class PagerController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {

    //public properties
    public var contentViewBackgroundColor: UIColor = UIColor.whiteColor()
    public var indicatorColor: UIColor = UIColor.redColor()
    public var tabsViewBackgroundColor: UIColor = UIColor.grayColor()
    public var dataSource: PagerDataSource!
    public var delegate: PagerDelegate?
    public var tabHeight: CGFloat = 44.0
    public var tabOffset: CGFloat = 56.0
    public var tabWidth: CGFloat = 128.0
    public var indicatorHeight: CGFloat = 5.0
    public var tabLocation: PagerTabLocation = PagerTabLocation.Top
    public var animation: PagerAnimation = PagerAnimation.During
    public var startFromSecondTab: Bool = false
    public var centerCurrentTab: Bool = false
    public var fixFormerTabsPositions: Bool = false
    public var fixLaterTabsPosition: Bool = false


    // Tab and content stuff
    internal var tabsView: UIScrollView?
    internal var pageViewController: UIPageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    internal var actualDelegate: UIScrollViewDelegate?
    internal var contentView: UIView {
        var contentView = self.pageViewController.view
        contentView!.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        contentView!.backgroundColor = self.contentViewBackgroundColor
        contentView!.bounds = self.view.bounds
        contentView!.tag = 34

        return contentView
    }


    // Tab and content cache
    internal var underlineStroke: UIView = UIView()
    internal var tabs: [UIView?] = []
    internal var contents: [UIViewController?] = []
    internal var tabCount: Int = 0
    internal var activeTabIndex: Int = 0
    internal var activeContentIndex: Int = 0
    internal var animatingToTab: Bool = false
    internal var defaultSetupDone: Bool = false
    internal var didTapOnTabView: Bool = false


    override public func viewDidLoad() {
        super.viewDidLoad()
        self.defaultSettings()
    }


    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !self.defaultSetupDone {
            self.defaultSetup()
        }
    }


    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.layoutSubViews()
    }


    override public func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
        self.layoutSubViews()
        self.changeActiveTabIndex(self.activeTabIndex)
    }


    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func defaultSettings() {
        for (view: UIView) in self.pageViewController.view!.subviews as [UIView] {
            if let uiview = view as? UIScrollView {
                self.actualDelegate = (view as UIScrollView).delegate
                (view as UIScrollView).delegate = self
            }
        }

        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
    }


    func defaultSetup() {
        // Empty tabs and contents
        for (tabView: UIView?) in self.tabs {
            tabView?.removeFromSuperview()
        }

        self.tabs.removeAll(keepCapacity: true)
        self.contents.removeAll(keepCapacity: true)
		self.underlineStroke.removeFromSuperview()

        // Get tabCount from dataSource
        self.tabCount = self.dataSource!.numberOfTabs(self)

        // Populate arrays with nil
        self.tabs = Array(count: self.tabCount, repeatedValue: nil)
        for (var i: Int = 0; i < self.tabCount; i++) {
            self.tabs.append(nil)
        }

        self.contents = Array(count: self.tabCount, repeatedValue: nil)
        for (var i: Int = 0; i < self.tabCount; i++) {
            self.contents.append(nil)
        }

        // Add tabsView
        if self.tabsView == nil {

            self.tabsView = UIScrollView(frame: CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), self.tabHeight))
            self.tabsView!.autoresizingMask = .FlexibleWidth
            self.tabsView!.backgroundColor = self.tabsViewBackgroundColor
            self.tabsView!.scrollsToTop = false
            self.tabsView?.bounces = false
            self.tabsView!.showsHorizontalScrollIndicator = false
            self.tabsView!.showsVerticalScrollIndicator = false
            self.tabsView!.tag = 38

            self.view.insertSubview(self.tabsView!, atIndex: 0)
        } else {
            self.tabsView = self.view.viewWithTag(38) as? UIScrollView
        }

        // Add tab views to _tabsView
        var contentSizeWidth: CGFloat = 0.0

        // Give the standard offset if fixFormerTabsPositions is provided as YES
        if (self.fixFormerTabsPositions) {
            // And if the centerCurrentTab is provided as YES fine tune the offset according to it
            if (self.centerCurrentTab) {
                contentSizeWidth = (CGRectGetWidth(self.tabsView!.frame) - self.tabWidth) / 2.0
            } else {
                contentSizeWidth = self.tabOffset
            }
        }


        for (var i: Int = 0; i < self.tabCount; i++) {
            var tabView: UIView? = self.tabViewAtIndex(i) as UIView?
            var frame: CGRect = tabView!.frame
            frame.origin.x = contentSizeWidth
            frame.size.width = self.tabWidth
            tabView!.frame = frame

            self.tabsView!.addSubview(tabView!)

            contentSizeWidth += CGRectGetWidth(tabView!.frame)

            // To capture tap events
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("handleTapGesture:"))
            tabView!.addGestureRecognizer(tapGestureRecognizer)
        }


        // Extend contentSizeWidth if fixLatterTabsPositions is provided YES
        if (self.fixLaterTabsPosition) {
            // And if the centerCurrentTab is provided as YES fine tune the content size according to it
            if (self.centerCurrentTab) {
                contentSizeWidth += (CGRectGetWidth(self.tabsView!.frame) - self.tabWidth) / 2.0
            } else {
                contentSizeWidth += CGRectGetWidth(self.tabsView!.frame) - self.tabWidth - self.tabOffset
            }
        }

        self.tabsView!.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight)

        self.view.insertSubview(self.contentView, atIndex: 0)

        // Select starting tab
        let index: Int = self.startFromSecondTab ? 1 : 0
        self.selectTabAtIndex(index, swipe: true)

        if (self.tabCount > 0) {
            //creates the indicator
            var rect: CGRect = self.tabViewAtIndex(self.activeContentIndex)!.frame
            rect.origin.y = rect.size.height - self.indicatorHeight
            rect.size.height = self.indicatorHeight

            self.underlineStroke = UIView(frame: rect)
            self.underlineStroke.backgroundColor = self.indicatorColor
            self.tabsView!.addSubview(self.underlineStroke)
        }

        // Set setup done
        self.defaultSetupDone = true
    }


    func layoutSubViews() {
        var topLayoutGuide: CGFloat = 0.0
        if  (self.navigationController?.navigationBar.translucent != false) {
            topLayoutGuide = UIApplication.sharedApplication().statusBarHidden ? 0.0 : 20.0
            topLayoutGuide += self.navigationController!.navigationBar.frame.size.height
        }

        var frame: CGRect = self.tabsView!.frame
        frame.origin.x = 0.0
        frame.origin.y = (self.tabLocation == .Top) ? topLayoutGuide : CGRectGetHeight(self.view.frame) - self.tabHeight
        frame.size.width = CGRectGetWidth(self.view.frame)
        frame.size.height = self.tabHeight
        self.tabsView!.frame = frame

        frame = self.contentView.frame
        frame.origin.x = 0.0
        frame.origin.y = (self.tabLocation == .Top) ? topLayoutGuide + CGRectGetHeight(self.tabsView!.frame) : topLayoutGuide
        frame.size.width = CGRectGetWidth(self.view.frame)

        frame.size.height = CGRectGetHeight(self.view.frame) - (topLayoutGuide + CGRectGetHeight(self.tabsView!.frame))

        if (self.tabBarController != nil) {
            frame.size.height -= CGRectGetHeight(self.tabBarController!.tabBar.frame)
        }

        self.contentView.frame = frame
    }


    @IBAction func handleTapGesture(sender: UITapGestureRecognizer) {
        let tabView: UIView = sender.view!

        let index: Int = self.tabs.find {
            $0 as UIView? == tabView
        }!

        if (self.activeTabIndex != index) {
            self.selectTabAtIndex(index)
        }
    }


    public func reloadData() {
        self.defaultSetup()
        self.view.setNeedsDisplay()
    }


    public func selectTabAtIndex(index: Int) {
        self .selectTabAtIndex(index, swipe: false)
    }


    func indexForViewController(viewController: UIViewController) -> Int {
        for (index, element) in enumerate(self.contents) {
            if (element == viewController) {
                return index
            }
        }
        return 0
    }


    func selectTabAtIndex(index: Int, swipe: Bool) {
        if (index >= self.tabCount) {
            return
        }

        self.didTapOnTabView = !swipe
        self.animatingToTab = true

        let previousIndex: Int = self.activeTabIndex

        self.changeActiveTabIndex(index)
        self.setActiveContentIndex(index)

        if self.delegate != nil {
            if (self.delegate!.respondsToSelector(Selector("didChangeTabToIndex:didChangeTabToIndex:"))) {
                self.delegate!.didChangeTabToIndex!(self, index: index)
            } else if (self.delegate!.respondsToSelector(Selector("didChangeTabToIndex:didChangeTabToIndex:fromIndex:"))) {
                self.delegate!.didChangeTabToIndex!(self, index: index, previousIndex: previousIndex)
            } else if (self.delegate!.respondsToSelector(Selector("didChangeTabToIndex:didChangeTabToIndex:fromIndex:didSwipe:"))) {
                self.delegate!.didChangeTabToIndex!(self, index: index, previousIndex: previousIndex, swipe: swipe)
            }
        }
    }


    func changeActiveTabIndex(newIndex: Int) {

        self.activeTabIndex = newIndex

        let tabView: UIView = self.tabViewAtIndex(self.activeTabIndex)!
        var frame: CGRect = tabView.frame

        if (self.centerCurrentTab) {
            frame.origin.x += (CGRectGetWidth(frame) / 2)
            frame.origin.x -= (CGRectGetWidth(self.tabsView!.frame) / 2)

            if (frame.origin.x < 0) {
                frame.origin.x = 0
            }

            if ((frame.origin.x + CGRectGetWidth(frame)) > self.tabsView!.contentSize.width) {
                frame.origin.x = (self.tabsView!.contentSize.width - CGRectGetWidth(self.tabsView!.frame))
            }
        } else {
            frame.origin.x -= self.tabOffset
            frame.size.width = CGRectGetWidth(self.tabsView!.frame)
        }

        self.tabsView!.scrollRectToVisible(frame, animated: true)
    }


    func tabViewAtIndex(index: Int) -> TabView? {
        if (index >= self.tabCount) {
            return nil
        }

        if (self.tabs[index] as UIView?) == nil {
            var tabViewContent: UIView = self.dataSource.tabViewForIndex(index, pager: self)
            tabViewContent.autoresizingMask = .FlexibleHeight | .FlexibleWidth


            var tabView: TabView = TabView(frame: CGRectMake(0.0, 0.0, self.tabWidth, self.tabHeight))
            tabView.addSubview(tabViewContent)
            tabView.clipsToBounds = true
            tabViewContent.center = tabView.center

            // Replace the null object with tabView
            self.tabs[index] = tabView
        }

        return self.tabs[index] as? TabView
    }


    func setNeedsReloadOptions() {
        // We should update contentSize property of our tabsView, so we should recalculate it with the new values
        var contentSizeWidth: CGFloat = 0.0

        // Give the standard offset if fixFormerTabsPositions is provided as YES
        if (self.fixFormerTabsPositions) {
            // And if the centerCurrentTab is provided as YES fine tune the offset according to it
            if (self.centerCurrentTab) {
                contentSizeWidth = (CGRectGetWidth(self.tabsView!.frame) - self.tabWidth) / 2.0
            } else {
                contentSizeWidth = self.tabOffset
            }
        }

        // Update every tab's frame
        for (var i = 0; i < self.tabCount; i++) {
            var tabView = self.tabViewAtIndex(i)
            var frame: CGRect = tabView!.frame
            frame.origin.x = contentSizeWidth
            frame.size.width = self.tabWidth
            tabView?.frame = frame
            contentSizeWidth += CGRectGetWidth(tabView!.frame)
        }

        // Extend contentSizeWidth if fixLatterTabsPositions is provided YES
        if (self.fixLaterTabsPosition) {

            // And if the centerCurrentTab is provided as YES fine tune the content size according to it
            if (self.centerCurrentTab) {
                contentSizeWidth += (CGRectGetWidth(self.tabsView!.frame) - self.tabWidth) / 2.0
            } else {
                contentSizeWidth += CGRectGetWidth(self.tabsView!.frame) - self.tabWidth - self.tabOffset
            }
        }
        // Update tabsView's contentSize with the new width
        self.tabsView!.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight)
    }


    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if (index >= self.tabCount || index < 0) {
            return nil
        }

        if (self.contents[index] as UIViewController?) == nil {
            var viewController: UIViewController

            if (self.dataSource!.respondsToSelector(Selector("controllerForTabAtIndex:pager:"))) {
                viewController = self.dataSource.controllerForTabAtIndex!(index, pager: self)
            } else if (self.dataSource!.respondsToSelector(Selector("viewForTabAtIndex:pager:"))) {

                var view: UIView = self.dataSource.viewForTabAtIndex!(index, pager: self)

                // Adjust view's bounds to match the pageView's bounds
                var pageView: UIView = self.view.viewWithTag(34)!
                view.frame = pageView.bounds

                viewController = UIViewController()
                viewController.view = view

            } else {
                viewController = UIViewController()
                viewController.view = UIView()
            }
            self.contents[index] = viewController
            self.addChildViewController(viewController)
        }
        return self.contents[index]
    }


    //page data source
    public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController)
        index--
        return self.viewControllerAtIndex(index)
    }


    public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index: Int = self.indexForViewController(viewController)
        index++
        return self.viewControllerAtIndex(index)
    }


    //page delegate
    public func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        var viewController: UIViewController = self.pageViewController.viewControllers[0] as UIViewController
        let index: Int = self.indexForViewController(viewController)
        self.selectTabAtIndex(index, swipe: true)
    }


    func setActiveContentIndex(activeContentIndex: Int) {
        // Get the desired viewController
        var viewController: UIViewController? = self.viewControllerAtIndex(activeContentIndex)!
        if (viewController == nil) {
            viewController = UIViewController()
            viewController!.view = UIView()
            viewController!.view.backgroundColor = UIColor.clearColor()
        }

        weak var wPageViewController: UIPageViewController? = self.pageViewController
        weak var wSelf: PagerController? = self

        if (activeContentIndex == self.activeContentIndex) {

            self.pageViewController.setViewControllers([viewController!], direction: .Forward, animated: false, completion: {
                (completed: Bool) -> Void in
                wSelf!.animatingToTab = false
            })

        } else if (!(activeContentIndex + 1 == self.activeContentIndex || activeContentIndex - 1 == self.activeContentIndex)) {

            let direction: UIPageViewControllerNavigationDirection = (activeContentIndex < self.activeContentIndex) ? .Reverse : .Forward

            self.pageViewController.setViewControllers([viewController!], direction: direction, animated: true, completion: {
                (completed: Bool) -> Void in

                wSelf?.animatingToTab = false

                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    wPageViewController!.setViewControllers([viewController!], direction: direction, animated: false, completion: nil)
                })
            })

        } else {
            let direction: UIPageViewControllerNavigationDirection = (activeContentIndex < self.activeContentIndex) ? .Reverse : .Forward

            self.pageViewController.setViewControllers([viewController!], direction: direction, animated: true, completion: {
                (completed: Bool) -> Void in
                wSelf!.animatingToTab = true
            })
        }

        // Clean out of sight contents
        var index: Int = self.activeContentIndex - 1
        if (index >= 0 && index != activeContentIndex && index != activeContentIndex - 1) {
            self.contents[index] = nil
        }
        index = self.activeContentIndex
        if (index != activeContentIndex - 1 && index != activeContentIndex && index != activeContentIndex + 1) {
            self.contents[index] = nil
        }
        index = self.activeContentIndex + 1
        if (index < self.contents.count && index != activeContentIndex && index != activeContentIndex + 1) {
            self.contents[index] = nil
        }
        self.activeContentIndex = activeContentIndex
    }


//UIScrollViewDelegate, Responding to Scrolling and Dragging
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidScroll:"))) {
                self.actualDelegate!.scrollViewDidScroll!(scrollView)
            }
        }

        let tabView: UIView = self.tabViewAtIndex(self.activeTabIndex)!

        if (!self.animatingToTab) {

            // Get the related tab view position
            var frame: CGRect = tabView.frame
            let movedRatio: CGFloat = (scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)) - 1
            frame.origin.x += movedRatio * CGRectGetWidth(frame)

            if (self.centerCurrentTab) {

                frame.origin.x += (frame.size.width / 2)
                frame.origin.x -= CGRectGetWidth(self.tabsView!.frame) / 2
                frame.size.width = CGRectGetWidth(self.tabsView!.frame)

                if (frame.origin.x < 0) {
                    frame.origin.x = 0
                }

                if ((frame.origin.x + frame.size.width) > self.tabsView!.contentSize.width) {
                    frame.origin.x = (self.tabsView!.contentSize.width - CGRectGetWidth(self.tabsView!.frame))
                }
            } else {

                frame.origin.x -= self.tabOffset
                frame.size.width = CGRectGetWidth(self.tabsView!.frame)
            }

            self.tabsView!.scrollRectToVisible(frame, animated: false)
        }

        var rect: CGRect = tabView.frame

        var updateIndicator = {
            (newX: CGFloat) -> Void in
            rect.origin.x = newX
            rect.origin.y = self.underlineStroke.frame.origin.y
            rect.size.height = self.underlineStroke.frame.size.height
            self.underlineStroke.frame = rect
        }

        var newX: CGFloat
        let width: CGFloat = CGRectGetWidth(self.view.frame)
        let distance: CGFloat = tabView.frame.size.width

        if (self.animation == PagerAnimation.During && !self.didTapOnTabView) {
            if (scrollView.panGestureRecognizer.translationInView(scrollView.superview!).x > 0) {
                var mov: CGFloat = width - scrollView.contentOffset.x
                newX = rect.origin.x - ((distance * mov) / width)
            } else {
                var mov: CGFloat = scrollView.contentOffset.x - width
                newX = rect.origin.x + ((distance * mov) / width)
            }
            updateIndicator(newX)
        } else if (self.animation == PagerAnimation.None) {
            newX = tabView.frame.origin.x
            updateIndicator(newX)
        } else if (self.animation == PagerAnimation.End || self.didTapOnTabView) {
            newX = tabView.frame.origin.x
            UIView.animateWithDuration(0.35, animations: {
                () -> Void in
                updateIndicator(newX)
            })
        }
    }


    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewWillBeginDragging:"))) {
                self.actualDelegate!.scrollViewWillBeginDragging!(scrollView)
            }
        }
    }


    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewWillEndDragging:withVelocity:targetContentOffset:"))) {
                self.actualDelegate!.scrollViewWillEndDragging!(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
            }
        }
    }


    public func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidEndDragging:willDecelerate:"))) {
                self.actualDelegate!.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
            }
        }
        self.didTapOnTabView = false
    }


    public func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewShouldScrollToTop:"))) {
                return self.actualDelegate!.scrollViewShouldScrollToTop!(scrollView)
            }
        }
        return false
    }


    public func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidScrollToTop:"))) {
                self.actualDelegate!.scrollViewDidScrollToTop!(scrollView)
            }
        }
    }


    public func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewWillBeginDecelerating:"))) {
                self.actualDelegate!.scrollViewWillBeginDecelerating!(scrollView)
            }
        }
    }

    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidEndDecelerating:"))) {
                self.actualDelegate!.scrollViewDidEndDecelerating!(scrollView)
            }
        }
        self.didTapOnTabView = false
    }


//UIScrollViewDelegate, Managing Zooming
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("viewForZoomingInScrollView:"))) {
                return self.actualDelegate!.viewForZoomingInScrollView!(scrollView)
            }
        }
        return nil
    }


    public func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewWillBeginZooming:withView:"))) {
                self.actualDelegate!.scrollViewWillBeginZooming!(scrollView, withView: view)
            }
        }
    }


    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidEndZooming:withView:atScale:"))) {
                self.actualDelegate!.scrollViewDidEndZooming!(scrollView, withView: view, atScale: scale)
            }
        }
    }

    public func scrollViewDidZoom(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidZoom:"))) {
                self.actualDelegate!.scrollViewDidZoom!(scrollView)
            }
        }
    }


//UIScrollViewDelegate, Responding to Scrolling Animations
    public func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if self.actualDelegate != nil {
            if (self.actualDelegate!.respondsToSelector(Selector("scrollViewDidEndScrollingAnimation:"))) {
                self.actualDelegate!.scrollViewDidEndScrollingAnimation!(scrollView)
            }
        }
        self.didTapOnTabView = false
    }
}


class TabView: UIView {

    override init() {
        super.init()
        self.backgroundColor = UIColor.clearColor()
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
}


extension Array {
    func find(includedElement: T -> Bool) -> Int? {
        for (idx, element) in enumerate(self) {
            if includedElement(element) {
                return idx
            }
        }
        return 0
    }
}

