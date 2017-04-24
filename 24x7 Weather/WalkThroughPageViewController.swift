//
//  WalkThroughPageViewController.swift
//  24x7 Weather
//
//  Created by Nikhil Wali on 18/04/17.
//  Copyright © 2017 Nikhil Wali. All rights reserved.
//

import UIKit

class WalkThroughPageViewController: UIPageViewController {
    
    var pageTitles = ["Weather Info", "Add City","Search City", "Share"]
    var pageImages = ["Main", "AddCity", "Search", "Share"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isStatusBarHidden = true

        self.dataSource = self
        
        if let initialWalkThroughVC = self.viewControllerAtIndex(index: 0) {
            setViewControllers([initialWalkThroughVC], direction: .forward, animated: true, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Navigation
    
    fileprivate func viewControllerAtIndex(index: Int) -> WalkThroughViewController? {
        if index == NSNotFound || index < 0 || index >= self.pageTitles.count {
            return nil
        }
        
        if let walkThroughVC = storyboard?.instantiateViewController(withIdentifier: "WalkThroughVC") as? WalkThroughViewController{
            
            walkThroughVC.walkThroughModel = WalkThroughModel(index: index, title: pageTitles[index], imageName: pageImages[index])
            
            if index == 3 {
                walkThroughVC.walkThroughModel?.isLast = true
            }
            
            return walkThroughVC
        }
        
        return nil
    }
    
}

// MARK: UIPageViewControllerDataSource

extension WalkThroughPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkThroughViewController).walkThroughModel!.index
        index -= 1
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkThroughViewController).walkThroughModel!.index
        index += 1
        return self.viewControllerAtIndex(index: index)
    }
    
}
