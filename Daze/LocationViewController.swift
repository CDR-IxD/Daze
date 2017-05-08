//
//  LocationViewController.swift
//  Daze
//
//  Created by David Sirkin on 4/25/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UITableViewController {
    
    @IBOutlet var editView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editView.backgroundView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        performSegue(withIdentifier: "locationContainerViewUnwind", sender: self)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        performSegue(withIdentifier: "locationContainerViewUnwind", sender: self)
    }
}
