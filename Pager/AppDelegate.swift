//
//  AppDelegate.swift
//  Pager
//
//  Created by Lucas Oceano on 12/03/2015.
//  Copyright (c) 2015 Cheesecake. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var navController: UINavigationController!

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		self.window = UIWindow(frame: UIScreen.main.bounds)
		let viewController = ViewController()

		let barButtomItem = UIBarButtonItem(title: "Purple Tab", style: .plain, target: viewController, action: #selector(ViewController.changeTab))

		//NavigationController with title and button
		navController = UINavigationController(rootViewController: viewController)
		navController.navigationBar.topItem?.title = "Pager"
		navController.navigationBar.topItem?.rightBarButtonItem = barButtomItem
		navController.navigationBar.hideBottomHairline()

		self.window!.rootViewController = navController
		self.window?.makeKeyAndVisible()

		//NavigationBar customization
		UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
		UINavigationBar.appearance().shadowImage = UIImage()
		UINavigationBar.appearance().barTintColor = UIColor(rgb: 0x00AA00)
		UINavigationBar.appearance().tintColor = UIColor.white

		//Setting Status Bar to be white instead of black
		UIApplication.shared.statusBarStyle = .lightContent

		return true
	}

}
