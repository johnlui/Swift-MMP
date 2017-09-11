//
//  Common.swift
//  Swift-MMP
//
//  Created by 吕文翰 on 2017/9/11.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

struct Common {
    // Swift 中， static let 才是真正可靠好用的单例模式
    static let screenWidth = UIScreen.main.bounds.maxX
    static let screenHeight = UIScreen.main.bounds.maxY
    static let rootViewController = UIApplication.shared.keyWindow?.rootViewController as! ViewController
}
