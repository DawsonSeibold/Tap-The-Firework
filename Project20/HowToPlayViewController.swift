//
//  HowToPlayViewController.swift
//  Project20
//
//  Created by Dawson Seibold on 4/23/16.
//  Copyright © 2016 Paul Hudson. All rights reserved.
//

import UIKit

class HowToPlayViewController: UIViewController, UIPageViewControllerDataSource {

    //Outlets
    
    //Varuables
    var moreInfo: moreInfoView!
    
    var pageViewController = UIPageViewController()
    var pageTitles = NSArray()
    var pageImages = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageTitles = NSArray(objects: "spark", "rocket")
        self.pageImages = NSArray(objects: "page1", "page2")
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("pageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVc = self.viewControllerAtIndex(0) 
        let viewControllers = NSArray(object: startVc)
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 70)
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        //More Info View
        moreInfo = NSBundle.mainBundle().loadNibNamed("moreInfoView", owner: self, options: nil).last as! moreInfoView
        moreInfo.frame = CGRectMake(0, self.view.frame.size.height - 140, self.view.frame.size.width, self.view.frame.size.height)
        self.view.addSubview(moreInfo)
        self.view.bringSubviewToFront(moreInfo)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    //MARK: Page View Controller Methods
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        
        if ((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
            return ContentViewController()
        }

        var vc: ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("contentViewController") as! ContentViewController
        
        vc.imageFile = self.pageImages[index] as! String
        vc.pageIndex = index
        
        return vc
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == self.pageTitles.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
