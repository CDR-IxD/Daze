//
//  UIButton.swift
//  Daze
//
//  Created by David Sirkin on 4/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

private var highlightedBackgroundColors = [UIButton: UIColor]()
private var unhighlightedBackgroundColors = [UIButton: UIColor]()

extension UIButton {
    
    @IBInspectable var highlightedBackgroundColor: UIColor? {
        get {
            return highlightedBackgroundColors[self]
        }
        set {
            highlightedBackgroundColors[self] = newValue
        }
    }
    
    override open var backgroundColor: UIColor? {
        get {
            return super.backgroundColor
        }
        set {
            unhighlightedBackgroundColors[self] = newValue
            super.backgroundColor = newValue
        }
    }
    
    override open var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if highlightedBackgroundColor != nil {
                super.backgroundColor = newValue ? highlightedBackgroundColor : unhighlightedBackgroundColors[self]
            }
            super.isHighlighted = newValue
        }
    }
}
