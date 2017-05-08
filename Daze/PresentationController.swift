//
//  PresentationController.swift
//  Daze
//
//  Created by David M Sirkin on 9/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class PresentationController: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    let dimmingView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        dimmingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func dimmingViewTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        dimmingView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        dimmingView.alpha = 0.0
        
        containerView!.addSubview(dimmingView)
        
        let coordinator = presentedViewController.transitionCoordinator
        coordinator!.animate(alongsideTransition: { _ in
            self.dimmingView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        coordinator!.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    override func containerViewWillLayoutSubviews() {
        dimmingView.center = containerView!.center
    }
}
