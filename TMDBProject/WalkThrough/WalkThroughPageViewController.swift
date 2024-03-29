//
//  WalkThroughPageViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/16.
//

import UIKit

class WalkThroughPageViewController: UIPageViewController {

    // MARK: - Properties
    
    var currentPageIndex = 0
    var pageIntro = ["앱을 통해 영화 정보를 확인하세요!", "영화를 눌러 자세한 정보를 확인하세요!", "극장 위치도 확인할 수 있습니다!"]
    var pageImages = ["intro1", "intro2", "intro3"]
    
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        if let startingViewController = showContentViewController(index: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Helper Functions
    
    func showContentViewController(index: Int) -> ContentViewController? {
        if index < 0 || index >= pageIntro.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "WalkThrough", bundle: nil)
        if let contentVC = storyboard.instantiateViewController(withIdentifier: "ContentViewController") as? ContentViewController {
            contentVC.index = index
            contentVC.introString = pageIntro[index]
            contentVC.imageString = pageImages[index]
            return contentVC
        }
        
        return nil
        
    }
    
    func nextPages() {
        currentPageIndex += 1
        if let nextVC = showContentViewController(index: currentPageIndex) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    


}


// MARK: - Extension: UIPageViewControllerDelegate

extension WalkThroughPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let storyboard = UIStoryboard(name: "WalkThrough", bundle: nil)
        if let walkThroughVC = storyboard.instantiateViewController(withIdentifier: "WalkThroughViewController") as? WalkThroughViewController {
            walkThroughVC.handler = {
                walkThroughVC.currentPageIndex = self.currentPageIndex
            }
            
            print(#function, "pageVC", currentPageIndex)
        }
    }
    
}

// MARK: - Extension: UIPageViewControllerDataSource

extension WalkThroughPageViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! ContentViewController).index
        index -= 1
        currentPageIndex -= 1
        return showContentViewController(index: index)

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        var index = (viewController as! ContentViewController).index
        index += 1
        currentPageIndex += 1
        return showContentViewController(index: index)

    }

}
