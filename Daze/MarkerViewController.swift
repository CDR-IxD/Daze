//
//  MarkerViewController.swift
//  Daze
//
//  Created by David M Sirkin on 1/31/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MarkerViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var markerView: UITableView!
    
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var radiusField: UITextField!
    @IBOutlet weak var monitorControl: UISegmentedControl!
    @IBOutlet weak var messageField: UITextField!
    
    @IBOutlet weak var label: UILabel!
    
    var marker: Marker!
    var header: UITableViewHeaderFooterView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        markerView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        
        titleField.delegate = self
        radiusField.delegate = self
        messageField.delegate = self
        
        if marker != nil {
            addMarkerData()
        }
    }
    
    // MARK: - Populate Data
    
    func getHeader() {
        header.textLabel?.lineBreakMode = .byWordWrapping
        header.textLabel?.text = marker.title
    }
    
    func getDistance() {
        let formatter = MKDistanceFormatter()
        formatter.unitStyle = .abbreviated
        
        let location = CLLocation(latitude: marker.latitude, longitude: marker.longitude)
        distance.text = formatter.string(fromDistance: locationManager.location!.distance(from: location))
    }
    
    func getAddress() {
        let location = CLLocation(latitude: marker.latitude, longitude: marker.longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            if error == nil && placemarks!.count > 0 {
                let lines = placemarks!.first?.addressDictionary?["FormattedAddressLines"] as! [String]
                self.address.text = lines.joined(separator: "\n")
                self.markerView.reloadData()
            }
        })
    }
    
    func getCoordinates() {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 4
        
        latitude.text = formatter.string(for: marker.latitude)
        longitude.text = formatter.string(for: marker.longitude)
    }
    
    func addMarkerData() {
        getHeader()
        getDistance()
        getAddress()
        getCoordinates()
        
        titleField.text = marker.title
        radiusField.text = "\(marker.radius)"
        monitorControl.selectedSegmentIndex = Int(marker.monitorForRegion.rawValue)
        messageField.text = marker.message
    }
    
    // MARK: - Update Markers
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    @IBAction func updateTitle(_ sender: UITextField) {
        header.textLabel?.text = sender.text
        marker.title = sender.text
        
        do {
            try getContext().save()
        } catch {
        }
    }
    
    @IBAction func updateRadius(_ sender: UITextField) {
        let mapVC = parent!.parent as! MapViewController
        
        mapVC.removeOverlay(marker)
        marker.radius = Double(sender.text!) ?? 0.0
        mapVC.addOverlay(marker)
        
        do {
            try getContext().save()
        } catch {
        }
    }
    
    @IBAction func updateRegionType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            marker.monitorForRegion = .didEnter
        case 1:
            marker.monitorForRegion = .didExit
        default:
            break
        }
        
        do {
            try getContext().save()
        } catch {
        }
    }
    
    @IBAction func updateMessage(_ sender: UITextField) {
        marker.message = sender.text
        
        do {
            try getContext().save()
        } catch {
        }
    }
    
    // MARK: - Format TableView
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        header = view as! UITableViewHeaderFooterView
        header.backgroundView?.backgroundColor = .clear
        header.textLabel?.font = UIFont(name: ".SFUIText-Semibold", size: 20)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return UITableViewAutomaticDimension
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == 2 {
            cell.separatorInset = UIEdgeInsetsMake(0, cell.bounds.size.width, 0, 0)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 7 {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let mapVC = parent!.parent as! MapViewController
            mapVC.removeMarker(marker)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            if string.isEmpty {
                return true
            }
            
            let replacedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.number(from: replacedString) != nil
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return false
    }
    
    // MARK: - Segue Transition
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationCVC = segue.destination as! LocationContainerViewController
        locationCVC.marker = marker
    }
    
    @IBAction func locationContainerViewUnwind(_ sender: UIStoryboardSegue) {
    }
}
