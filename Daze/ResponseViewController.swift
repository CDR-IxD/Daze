//
//  ResponseViewController.swift
//  Daze
//
//  Created by David M Sirkin on 9/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class ResponseViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var touchView: UIView!
    
    let locationManager = CLLocationManager()
    
    var coordinate: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.mapType = .hybrid
        
        let region = MKCoordinateRegionMakeWithDistance(locationManager.location!.coordinate, 250, 250)
        mapView.setRegion(region, animated: false)
    }
    
    // MARK: - Gesture Interaction
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchView.isHidden = false
        touchesMoved(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchView.center = touches.first!.location(in: view)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        coordinate = mapView.convert(touches.first!.location(in: mapView), toCoordinateFrom: mapView)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        //file.save("\(coordinate.latitude), \(coordinate.longitude)")
        performSegue(withIdentifier: "responseViewUnwind", sender: self)
    }
}
