//
//  MarkerContainerViewController.swift
//  Daze
//
//  Created by David M Sirkin on 9/17/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

extension MarkerContainerViewController {
    
}

class MarkerContainerViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var markerContainerView: UIView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var markerView: UITableView!
    
    var fullView: CGFloat {
        return UIScreen.main.bounds.origin.y + 43
    }
    var partView: CGFloat {
        return UIScreen.main.bounds.height - 189
    }
    var headView: CGFloat {
        return UIScreen.main.bounds.height - 78
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        panGesture.delegate = self
        markerView = markerContainerView.subviews.first as! UITableView!
    }
    
    func open() {
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            self.view.frame.origin.y = self.partView
        })
    }
    
    func close() {
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
            self.view.frame.origin.y = UIScreen.main.bounds.height
        })
    }
    
    @IBAction func deselectAnnotation(_ sender: Any) {
        let mapVC = parent as! MapViewController
        mapVC.deselectAnnotation()
    }
    
    @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        let y = view.frame.minY
        if (y + translation.y >= fullView) && (y + translation.y <= headView) && (markerView.contentOffset.y == 0) {
            view.frame.origin.y = y + translation.y
            sender.setTranslation(CGPoint.zero, in: view)
        }
        
        if sender.state == .ended {
            var duration = velocity.y < 0 ? Double((fullView - y) / velocity.y) : Double((partView - y) / velocity.y)
            
            duration = min(1.0, max(0.5, duration))
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.0, options: .allowUserInteraction, animations: {
                if y >= self.partView {
                    self.view.frame.origin.y = velocity.y >= 0 ? self.headView : self.partView
                } else {
                    self.view.frame.origin.y = velocity.y >= 0 ? self.partView : self.fullView
                }
            })
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        markerView.isScrollEnabled = view.frame.minY == fullView ? true : false
        return true
    }
}
