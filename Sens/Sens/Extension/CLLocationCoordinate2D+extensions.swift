//
//  CLLocationCoordinate2D+extensions.swift
//  Sens
//
//  Created by Bruno Cardoso Ambrosio on 15/11/19.
//  Copyright © 2019 Bruno Cardoso Ambrosio. All rights reserved.
//

import Foundation
import CoreLocation
import FirebaseFirestore.FIRGeoPoint

extension CLLocationCoordinate2D {
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
    
    static func fromGeoPoint(value: GeoPoint) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: value.latitude, longitude: value.longitude)
    }
}
