//
//  TutorialPageViewController.swift
//  TestInk
//
//  Created by C4Q on 3/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {

    var photos = ["photo1", "photo2", "photo3", "photo4", "photo5"]
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let viewController = showImageViewController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        
    }
    
    public func storyboardInstance() -> TutorialPageViewController {
        let storyboard = UIStoryboard(name: "Tutorial", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TutorialPageViewController") as! TutorialPageViewController
        return vc
    }

    func showImageViewController(_ index: Int) -> ImageViewController? {
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController {
            page.photoName = photos[index]
            page.photoIndex = index
            return page
        }
        return nil
    }
    
}
//MARK: implementation of UIPageViewControllerDataSource
extension TutorialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ImageViewController,
        let index = viewController.photoIndex,
            index > 0 {
            return showImageViewController(index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? ImageViewController,
        let index = viewController.photoIndex,
            (index + 1) < photos.count {
            return showImageViewController(index + 1)
        }
        return nil
    }
    
    // MARK: UIPageControl
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return photos.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndex ?? 0
    }
}
