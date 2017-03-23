//
//  TabBarVC.swift
//  Pager
//
//  Created by Antonio Alves on 11/4/16.
//  Copyright © 2016 Cheesecake. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let vc1 = UIViewController()
        let nvc1 = UINavigationController(rootViewController: vc1)
        
        let vc2 = UIViewController()
        let nvc2 = UINavigationController(rootViewController: vc2)

        
        let vc3 = ViewController()
        let barButtomItem = UIBarButtonItem(title: "Purple Tab", style: .plain, target: vc3, action: #selector(ViewController.changeTab))
        
        //NavigationController with title and button
        let navController = UINavigationController(rootViewController: vc3)
        navController.navigationBar.topItem?.title = "Pager"
        navController.navigationBar.topItem?.rightBarButtonItem = barButtomItem
        navController.navigationBar.hideBottomHairline()
        

        
        let tabs = [nvc1, nvc2, navController]
        
        self.setViewControllers(tabs, animated: true)
        
        nvc1.tabBarItem = UITabBarItem(title: "Test1", image: nil, tag: 1)
        nvc2.tabBarItem = UITabBarItem(title: "Test2", image: nil, tag: 2)
        navController.tabBarItem = UITabBarItem(title: "PagerVC", image: nil, tag: 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

