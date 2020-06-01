//
//  PagesViewController.swift
//  db01
//
//  Created by Tanaka Soushi on 2020/05/27.
//  Copyright © 2020 Tanaka Soushi. All rights reserved.
//

import UIKit

class PagesViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    var pageViewController:UIPageViewController!
    let pageControl = UIPageControl()
    var vc:[UIViewController]?

    override func viewDidLoad() {
            super.viewDidLoad()
        
        title = "COVID感染状況"
        
        pageViewController = UIPageViewController(transitionStyle:.scroll,
        navigationOrientation: .horizontal,
        options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = view.frame
        view.addSubview(pageViewController.view!)
            
        
        let position = UIScreen.main.bounds.size
        var pageHeight:CGFloat = 0
        let viewHeight = view.frame.size.height
        if viewHeight == 667, viewHeight == 736 {
            pageHeight = 25
        } 
        pageControl.frame = CGRect(x: position.width / 2 - 19.5, y: position.height - 100 + pageHeight, width: 39, height: 37)
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.pageIndicatorTintColor = .black
        pageControl.currentPageIndicatorTintColor = .green
        view.addSubview(pageControl)
        
        let uiView = UIView()
        uiView.frame = CGRect(x: 0, y: position.height - 34, width: view.frame.size.width, height: 34)
        uiView.backgroundColor = .init(red: 0/255, green: 30/255, blue: 120/255, alpha: 0.5)
        view.addSubview(uiView)
    }
    func getFirst() -> CustomTableView {
        return storyboard!.instantiateViewController(withIdentifier: "FirstViewController") as! CustomTableView
    }
    func getSecond() -> SecondViewController {
        return storyboard!.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }

    func getThird() -> ThirdViewController {
        return storyboard!.instantiateViewController(withIdentifier: "ThirdViewController") as! ThirdViewController
    }
    //右スワイプ時に呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of: SecondViewController.self) {
            return getThird()
        } else if viewController.isKind(of: CustomTableView.self) {
            return getSecond()
        } else {
            return nil
        }
        
    }
    //左スワイプ時に呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKind(of:SecondViewController.self) {
            return getFirst()
        } else if viewController.isKind(of:ThirdViewController.self) {
            return getSecond()
        } else {
            return nil
        }
        
    }
    /*スワイプに伴う処理(pagecontrolのcurrentPageの
    indexのインクリメント,デクリメントなど)はここに書く*/
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {

        if transitionCompleted {
            if let currentVC = pageViewController.viewControllers?[0] {
                let vcName = String(describing: type(of:currentVC))
                if vcName == "CustomTableView" {
                    self.pageControl.currentPage = 0
                } else if vcName == "SecondViewController" {
                    self.pageControl.currentPage = 1
                } else if vcName == "ThirdViewController" {
                    self.pageControl.currentPage = 2
                } else {
                    print("クラスの取得に失敗しました。")
                }
            }
        }
    }
}
