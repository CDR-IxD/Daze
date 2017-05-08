//
//  AnimatedTransitioning.swift
//  Daze
//
//  Created by David M Sirkin on 9/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    /*
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        super.init()
    }
    */
    var isPresentation: Bool
    let duration = 0.5
    
    init(isPresentation: Bool) {
        self.isPresentation = isPresentation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    /*
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        var frame = inView.bounds
        
        switch transitionType {
        case .presenting:
            frame.origin.y = frame.size.height
            toView.frame = frame
            
            inView.addSubview(toView)
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                toView.frame = inView.bounds
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
            toView.frame = frame
            //inView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                frame.origin.y = frame.size.height
                fromView.frame = frame
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    */
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else { return }
        
        let fromView = fromVC.view
        let toView = toVC.view
        
        if isPresentation {
            transitionContext.containerView.addSubview(toView!)
        }
        
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC.view
        animatingView?.frame = transitionContext.finalFrame(for: animatingVC)
        
        if isPresentation {
            animatingView?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            animatingView?.alpha = 0.0
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            animatingView?.alpha = self.isPresentation ? 1.0 : 0.0
            if self.isPresentation {
                animatingView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }, completion:{ completed in
            if !self.isPresentation {
                fromView?.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
    }
}
