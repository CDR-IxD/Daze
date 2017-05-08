//
//  TransitioningDelegate.swift
//  Daze
//
//  Created by David M Sirkin on 9/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatedTransitioning(isPresentation: true)
        //return AnimatedTransitioning(transitionType: .presenting)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AnimatedTransitioning(isPresentation: false)
        //return AnimatedTransitioning(transitionType: .dismissing)
    }
}
