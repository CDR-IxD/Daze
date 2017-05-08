//
//  Marker+CoreDataClass.swift
//  Daze
//
//  Created by David Sirkin on 4/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import CoreData
import MapKit

enum MonitorType: Int16 {
    case didEnter, didExit
}

public class Marker: NSManagedObject, MKAnnotation {
    
    convenience init(at coordinate: CLLocationCoordinate2D, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Marker", in: context)
        self.init(entity: entity!, insertInto: context)
        
        identifier = UUID().uuidString
        
        latitude = coordinate.latitude
        longitude = coordinate.longitude        
    }
    
    public var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude as Double, longitude: longitude as Double)
        }
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
    public var region: CLCircularRegion {
        get {
            return CLCircularRegion(center: coordinate, radius: radius, identifier: identifier!)
        }
        set {
            latitude = newValue.center.latitude
            longitude = newValue.center.longitude
            radius = newValue.radius
            identifier = newValue.identifier
        }
    }
    
    var monitorForRegion: MonitorType {
        get {
            return MonitorType(rawValue: monitor)!
        }
        set {
            monitor = Int16(newValue.rawValue)
        }
    }
}
