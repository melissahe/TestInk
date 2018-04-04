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
        
        let textAttributes = [NSAttributedStringKey.foregroundColor : UIColor.Custom.whiteSmoke]
        let barColor = Stylesheet.Colors.LightBlue
        let tintColor = UIColor.Custom.whiteSmoke
        let feedImageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        let profileImageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.navigationBar.isTranslucent = false
        feedNavController.navigationBar.titleTextAttributes = textAttributes
        feedNavController.navigationBar.barTintColor = barColor
        feedNavController.navigationBar.tintColor = tintColor
        let feedTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "feedUnfilledIcon"), tag: 0)
        feedNavController.tabBarItem = feedTabBarItem
        feedTabBarItem.imageInsets = feedImageInsets
        feedTabBarItem.selectedImage = #imageLiteral(resourceName: "feedFilledIcon")
        
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.navigationBar.isTranslucent = false
        profileNavController.navigationBar.titleTextAttributes = textAttributes
        profileNavController.navigationBar.barTintColor = barColor
        profileNavController.navigationBar.tintColor = tintColor
        profileNavController.navigationBar.shadowImage = UIImage()
        profileNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let profileTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "favoriteUnfilledIcon"), tag: 1)
        profileNavController.tabBarItem = profileTabBarItem
        profileTabBarItem.imageInsets = profileImageInsets
        profileTabBarItem.selectedImage = #imageLiteral(resourceName: "favoriteFilledIcon")
        
        self.viewControllers = [feedNavController, profileNavController]
        self.tabBar.barTintColor = UIColor.Custom.lapisLazuli
        self.tabBar.tintColor = UIColor.Custom.mediumSkyBlue
        self.tabBar.unselectedItemTintColor = UIColor.Custom.gainsboro
    }

}
