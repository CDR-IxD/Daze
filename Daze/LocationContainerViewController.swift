//
//  LocationContainerViewController.swift
//  Daze
//
//  Created by David Sirkin on 4/26/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class LocationContainerViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    var marker: Marker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let region = MKCoordinateRegionMakeWithDistance(marker.coordinate, 250, 250)
        mapView.setRegion(region, animated: false)
    }
    
    @IBAction func userTrackingAction(_ sender: UIButton) {
        let camera = mapView.camera
        camera.centerCoordinate = mapView.userLocation.coordinate
        mapView.setCamera(camera, animated: true)
    }
    /*
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("change")
        
        UIView.animate(withDuration: 2) {
            self.mapView.camera = self.camera
        }
    }
    */
    @IBAction func removeMarkerAction(_ sender: UIButton) {
        performSegue(withIdentifier: "locationContainerViewUnwind", sender: self)
    }
}
