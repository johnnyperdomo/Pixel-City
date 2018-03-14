//
//  DroppablePin.swift
//  pixel-city
//
//  Created by Johnny Perdomo on 3/14/18.
//  Copyright © 2018 Johnny Perdomo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D //holds the coordinate, dynamic: needed to make changes to coordinates a certain way
    var identifier: String//identifier, helps us identify a certain pin
    
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) { //initialize it
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
