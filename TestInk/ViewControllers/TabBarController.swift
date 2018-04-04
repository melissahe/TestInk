//
//  TabBarController.swift
//  TestInk
//
//  Created by C4Q on 4/3/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileVC = ProfileVC()
        let feedVC = FeedVC()
        let upLoadVC = UploadVC()
        
        let textAttributes = [NSAttributedStringKey.foregroundColor : UIColor.Custom.whiteSmoke]
        let barColor = Stylesheet.Colors.LightBlue
        let tintColor = UIColor.Custom.whiteSmoke
        //Feed NavController
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.navigationBar.isTranslucent = false
        feedNavController.navigationBar.titleTextAttributes = textAttributes
        feedNavController.navigationBar.barTintColor = barColor
        feedNavController.navigationBar.tintColor = tintColor
        let feedTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "feedIcon"), tag: 0)
        feedNavController.tabBarItem = feedTabBarItem
        
        //Upload NavController
        let upLoadNavController = UINavigationController(rootViewController: upLoadVC)
        upLoadNavController.navigationBar.isTranslucent = false
        upLoadNavController.navigationBar.titleTextAttributes = textAttributes
        upLoadNavController.navigationBar.barTintColor = barColor
        upLoadNavController.navigationBar.tintColor = tintColor
        upLoadNavController.navigationBar.shadowImage = UIImage()
        upLoadNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        upLoadNavController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "icons8-plus-withCircle"), tag: 1)
        //Profile NavController
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.navigationBar.isTranslucent = false
        profileNavController.navigationBar.titleTextAttributes = textAttributes
        profileNavController.navigationBar.barTintColor = barColor
        profileNavController.navigationBar.tintColor = tintColor
        profileNavController.navigationBar.shadowImage = UIImage()
        profileNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        profileNavController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "favoriteIcon"), tag: 2)
        //
        self.viewControllers = [feedNavController, upLoadNavController, profileNavController]
        self.tabBar.barTintColor = Stylesheet.Colors.Lapislazuli
        self.tabBar.tintColor = Stylesheet.Colors.MediumSkyBlue
        self.tabBar.unselectedItemTintColor = Stylesheet.Colors.Gainsboro
    }

}
