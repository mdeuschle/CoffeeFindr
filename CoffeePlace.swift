//
//  CoffeePlace.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/13/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import Foundation
import MapKit

class CoffeePlace {

    let name: String?
    let location: CLLocation
    let mapItem: MKMapItem
    let streetNumber: String?
    let streetName: String?
    let latitude: Double
    let longitude: Double

    init(mapItem: MKMapItem) {

        name = mapItem.name
        location = mapItem.placemark.location!
        streetNumber = mapItem.placemark.subThoroughfare
        streetName = mapItem.placemark.thoroughfare
        latitude = (mapItem.placemark.location?.coordinate.latitude)!
        longitude = (mapItem.placemark.location?.coordinate.longitude)!
        self.mapItem = mapItem
    
    }

    func distanceFromLocation(location: CLLocation) -> Double {
        return location.distanceFromLocation(self.location)
    }

}


