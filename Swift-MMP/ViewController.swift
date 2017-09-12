//
//  ViewController.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/11.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let sideViewWidthMultiple: CGFloat = 0.6

    var homeViewController: HomeViewController!
    var sideViewController: SideViewController!
    
//    var mainView: UIView!
    var blackCover: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.mainView = UIView(frame: self.view.frame)
        self.homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        self.homeViewController.viewController = self
        self.view.addSubview(self.homeViewController.view)
        
        self.sideViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "sideVC") as! SideViewController

        self.sideViewController.view.frame = CGRect(x: 0, y: 0, width: Common.screenWidth * self.sideViewWidthMultiple, height: Common.screenHeight)
        self.sideViewController.view.center = CGPoint(x: Common.screenWidth * self.sideViewWidthMultiple * -0.5, y: self.sideViewController.view.center.y)
        
        // 把侧滑菜单视图加入根容器
        self.view.addSubview(self.sideViewController.view)
        
        self.blackCover = UIView(frame: self.view.frame)
        self.blackCover.backgroundColor = UIColor.black
        self.blackCover.alpha = 0
        self.blackCover.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideSide)))
        self.view.addSubview(self.blackCover)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSide() {
        print("show")
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.sideViewController.view.center = CGPoint(x: Common.screenWidth * self.sideViewWidthMultiple * 0.5, y: self.sideViewController.view.center.y)
            self.blackCover.center = CGPoint(x: self.view.center.x + Common.screenWidth * self.sideViewWidthMultiple, y: self.sideViewController.view.center.y)
            self.blackCover.alpha = 0.6
        }) { (status) in
            if (status) {}
        }
    }
    
    func hideSide() {
        print("hide")
        UIView.animate(withDuration: 0.2, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.sideViewController.view.center = CGPoint(x: Common.screenWidth * self.sideViewWidthMultiple * -0.5, y: self.sideViewController.view.center.y)
            self.blackCover.center = self.view.center
            self.blackCover.alpha = 0
        }) { (status) in
            if (status) {}
        }
    }


}

