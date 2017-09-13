//
//  UIImage.swift
//  Swift-MMP
//
//  Created by John Lui on 2017/9/13.
//  Copyright © 2017年 John Lui. All rights reserved.
//

import UIKit

extension UIImage {
    
    func resizeToSize(_ size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
