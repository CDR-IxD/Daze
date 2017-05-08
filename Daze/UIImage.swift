//
//  UIImage.swift
//  Daze
//
//  Created by David M Sirkin on 10/2/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaledToSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
