//
//  MapViewController.swift
//  Daze
//
//  Created by David M Sirkin on 9/13/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    @IBOutlet var mapView: MKMapView!    
    @IBOutlet var detailToolbar: UIToolbar!
    @IBOutlet var trackingToolbar: UIToolbar!
    
    let locationManager = CLLocationManager()
    var monitoredRegions = Set<String>()
    
    var markerCVC: MarkerContainerViewController!
    var alertTransitioningDelegate = TransitioningDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        
        mapView.delegate = self
        mapView.layoutMargins = UIEdgeInsets(top: 105, left: 8, bottom: 0, right: 8)
        
        trackingToolbar.items?.insert(MKUserTrackingBarButtonItem(mapView: mapView), at: 1)
        
        NotificationCenter.default.addObserver(self, selector: #selector(archiveCamera), name: NSNotification.Name(rawValue: "didEnterBackground"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(raiseAlert), name: NSNotification.Name(rawValue: "didReceiveData"), object: nil)
        
        addMarkerViewController()
        unarchiveCamera()
        addMarkers()
    }
    
    // MARK: - Archive MKMapCamera
    
    func archiveCamera() {
        let camera = NSKeyedArchiver.archivedData(withRootObject: mapView.camera)
        UserDefaults.standard.set(camera, forKey: "camera")
    }
    
    func unarchiveCamera() {
        if let data = UserDefaults.standard.object(forKey: "camera") as? Data {
            let camera = NSKeyedUnarchiver.unarchiveObject(with: data) as! MKMapCamera
            mapView.setCamera(camera, animated: false)
        }
    }
    
    // MARK: - Child ViewController
    
    func addMarkerViewController() {
        markerCVC = storyboard!.instantiateViewController(withIdentifier: "markerCVC") as! MarkerContainerViewController
        markerCVC.view.frame.origin.y = view.frame.maxY
        addChildViewController(markerCVC)
        view.addSubview(markerCVC.view)
        markerCVC.didMove(toParentViewController: self)
    }
    
    // MARK: - Add or Remove Markers
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func addMarkers() {
        do {
            let markers = try getContext().fetch(Marker.fetchRequest()) as! [Marker]
            
            for marker in markers {
                mapView.addAnnotation(marker)
                mapView.add(MKCircle(center: marker.coordinate, radius: marker.radius))
            }
        } catch {
        }
    }
    
    func addMarker(_ coordinate: CLLocationCoordinate2D) {
        let marker = Marker(at: coordinate, context: getContext())
        
        do {
            try getContext().save()
            
            mapView.addAnnotation(marker)
            mapView.selectAnnotation(marker, animated: true)
            mapView.add(MKCircle(center: coordinate, radius: 100))
        } catch {
        }
    }
    
    func removeMarker(_ marker: Marker) {
        mapView.removeAnnotation(marker)
        removeOverlay(marker)
        
        getContext().delete(marker)
        
        do {
            try getContext().save()
        } catch {
        }
    }
    
    // MARK: - Monitor Marker Regions
        
    func raiseAlert() {
        performSegue(withIdentifier: "alertViewSegue", sender: self)
    }
    
    func didEnterRegion(_ marker: Marker) {
        if marker.monitorForRegion == .didEnter {
            raiseAlert()
        }
    }
    
    func didExitRegion(_ marker: Marker) {
        if marker.monitorForRegion == .didExit {
            raiseAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        do {
            let markers = try getContext().fetch(Marker.fetchRequest()) as! [Marker]
            
            for marker in markers {
                if marker.region.contains(locations.last!.coordinate) && !monitoredRegions.contains(marker.identifier!) {
                    monitoredRegions.insert(marker.identifier!)
                    didEnterRegion(marker)
                }
                if !marker.region.contains(locations.last!.coordinate) && monitoredRegions.contains(marker.identifier!) {
                    monitoredRegions.remove(marker.identifier!)
                    didExitRegion(marker)
                }
            }
        } catch {
        }
    }
    
    // MARK: - Gesture Interaction
    
    @IBAction func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let coordinate = mapView.convert(sender.location(in: mapView), toCoordinateFrom: mapView)
        
        if sender.state == .began {
            addMarker(coordinate)
        }
    }
    
    @IBAction func handleDetailDisclosure(_ sender: UIButton) {
    }
    
    // MARK: - MapView Annotations
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "marker")
        
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "marker")
        } else {
            view?.annotation = annotation
        }
        view?.image = #imageLiteral(resourceName: "Pin").scaledToSize(size: CGSize(width: 28, height: 35))
        
        view?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.975)
        view?.layer.shadowOffset = CGSize(width: 0, height: 2.5)
        view?.layer.shadowOpacity = 0.2
        view?.layer.shadowRadius = 5
        
        return view
    }
    
    func deselectAnnotation() {
        mapView.deselectAnnotation(mapView.selectedAnnotations.first, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is Marker {
            UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                view.image = #imageLiteral(resourceName: "Pin").scaledToSize(size: CGSize(width: 60, height: 74))
            })
            
            let markerVC = markerCVC.childViewControllers.first as! MarkerViewController
            markerVC.marker = view.annotation as! Marker
            markerVC.viewDidLoad()
        
            markerCVC.open()
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            if view.annotation is Marker {
                view.image = #imageLiteral(resourceName: "Pin").scaledToSize(size: CGSize(width: 28, height: 35))
            }
        })
        markerCVC.close()
    }
    
    // MARK: - Annotation Overlay
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKCircleRenderer(overlay: overlay)
        renderer.fillColor = view.tintColor.withAlphaComponent(0.2)
        renderer.strokeColor = view.tintColor.withAlphaComponent(0.6)
        renderer.lineWidth = 1
        return renderer
    }
    
    func addOverlay(_ marker: Marker) {
        mapView?.add(MKCircle(center: marker.coordinate, radius: marker.radius))
    }
    
    func removeOverlay(_ marker: Marker) {
        for overlay in mapView.overlays as! [MKCircle] {
            if overlay.coordinate.latitude == marker.coordinate.latitude &&
                overlay.coordinate.longitude == marker.coordinate.longitude &&
                overlay.radius == marker.radius {
                mapView.remove(overlay)
            }
        }
    }
    
    // MARK: - Segue Transitions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "alertViewSegue" {
            let alertVC = segue.destination as! AlertViewController
            alertVC.transitioningDelegate = alertTransitioningDelegate
            alertVC.modalPresentationStyle = .custom
        }
    }
    
    @IBAction func alertViewUnwind(_ sender: UIStoryboardSegue) {
        DispatchQueue.main.async() {
            self.performSegue(withIdentifier: "responseViewSegue", sender: self )
        }
    }
    
    @IBAction func responseViewUnwind(_ sender: UIStoryboardSegue) {
    }
}
