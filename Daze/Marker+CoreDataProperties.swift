//
//  Marker+CoreDataProperties.swift
//  Daze
//
//  Created by David Sirkin on 4/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import CoreData

extension Marker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Marker> {
        return NSFetchRequest<Marker>(entityName: "Marker")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var message: String?
    @NSManaged public var radius: Double
    @NSManaged public var title: String?
    @NSManaged public var monitor: Int16

}
