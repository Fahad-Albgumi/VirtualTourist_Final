//
//  pinAnnotation.swift
//  VirtualTourist
//
//  Created by fahad on 10/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//

import Foundation
import MapKit

extension Pin: MKAnnotation {
    public var coordinate: CLLocationCoordinate2D {
        let latDegrees = CLLocationDegrees(latitude)
        let longDegrees = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: latDegrees, longitude: longDegrees)
    }
}
