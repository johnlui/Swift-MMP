//
//  ViewController.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/11.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var homeViewController: HomeViewController!
    
//    var mainView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.mainView = UIView(frame: self.view.frame)
        self.homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        self.view.addSubview(self.homeViewController.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

