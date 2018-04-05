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
        
        let textAttributes = [NSAttributedStringKey.foregroundColor : UIColor.Custom.lapisLazuli]
        let barColor = Stylesheet.Colors.LightBlue
        let tintColor = Stylesheet.Colors.Lapislazuli
        let feedImageInsets = UIEdgeInsets(top: 7, left: 0, bottom: -7, right: 0)
        let uploadImageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        let profileImageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        
        
        //Feed NavController
        let feedNavController = UINavigationController(rootViewController: feedVC)
        feedNavController.navigationBar.isTranslucent = false
        feedNavController.navigationBar.shadowImage = UIImage()
        feedNavController.navigationBar.titleTextAttributes = textAttributes
        feedNavController.navigationBar.barTintColor = barColor
        feedNavController.navigationBar.tintColor = tintColor
        let feedTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "feedUnfilledIcon"), tag: 0)
        feedNavController.tabBarItem = feedTabBarItem
        feedTabBarItem.imageInsets = feedImageInsets
        feedTabBarItem.selectedImage = #imageLiteral(resourceName: "feedFilledIcon")
        
        //Upload NavController
        let upLoadNavController = UINavigationController(rootViewController: upLoadVC)
        upLoadNavController.navigationBar.isTranslucent = false
        upLoadNavController.navigationBar.titleTextAttributes = textAttributes
        upLoadNavController.navigationBar.barTintColor = barColor
        upLoadNavController.navigationBar.tintColor = tintColor
        upLoadNavController.navigationBar.shadowImage = UIImage()
        upLoadNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        upLoadNavController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "uploadUnfilledIcon"), tag: 1)
        upLoadNavController.tabBarItem.selectedImage = #imageLiteral(resourceName: "uploadFilledIcon")
        upLoadNavController.tabBarItem.imageInsets = uploadImageInsets
        
        //Profile NavController
        let profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.navigationBar.isTranslucent = false
        profileNavController.navigationBar.titleTextAttributes = textAttributes
        profileNavController.navigationBar.barTintColor = barColor
        profileNavController.navigationBar.tintColor = tintColor
        profileNavController.navigationBar.shadowImage = UIImage()
        profileNavController.navigationBar.setBackgroundImage(UIImage(), for: .default)

        let profileTabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "favoriteUnfilledIcon"), tag: 2)
        profileNavController.tabBarItem = profileTabBarItem
        profileTabBarItem.imageInsets = profileImageInsets
        profileTabBarItem.selectedImage = #imageLiteral(resourceName: "favoriteFilledIcon")

        
        self.viewControllers = [feedNavController, upLoadNavController, profileNavController]
        self.tabBar.barTintColor = Stylesheet.Colors.Lapislazuli
        self.tabBar.tintColor = Stylesheet.Colors.LightBlue
        self.tabBar.unselectedItemTintColor = Stylesheet.Colors.LightBlue
    }

}
