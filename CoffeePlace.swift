//
//  CoffeePlace.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/13/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import Foundation
import MapKit

class CoffeePlace: NSObject {

    let name: String?
    let location: CLLocation
    let mapItem: MKMapItem

    init(mapItem: MKMapItem){
        name = mapItem.name
        location = mapItem.placemark.location!
        self.mapItem = mapItem
    }

    func distanceFromLocation(location: CLLocation) -> Double {
        return location.distanceFromLocation(self.location)
    }

//    func travelTimeFromLocation(mapItem: MKMapItem, vehicle: MKDirectionsTransportType,completionHandler: (timeInterval: NSTimeInterval) -> Void) {
//        let request = MKDirectionsRequest()
//        request.source = mapItem
//        request.transportType = vehicle
//        request.destination = self.mapItem
//        let directions = MKDirections(request: request)
//        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
//            let routes = response?.routes
//            let route = routes?.first
//            completionHandler(timeInterval: route!.expectedTravelTime)
//        }
//    }
//
//    func getDirectionFrom(sourceItem: MKMapItem, completionHandler: (MKRoute) -> Void ){
//        let request = MKDirectionsRequest()
//        request.source = sourceItem
//        request.destination = mapItem
//        let directions = MKDirections(request: request)
//        directions.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
//            let routes = response?.routes
//            if let route = routes?.first{
//                completionHandler(route)
//            }
//        }
//    }

//    var name: String
//    var latitude: Double
//    var longitude: Double
//    var streetNumber: String?
//    var streetName: String?
//    var city: String?
//    var pizzaLocation: CLLocation
//
//    init(mapItem: MKMapItem) {
//
//        name = mapItem.name!
//        latitude = (mapItem.placemark.location?.coordinate.latitude)!
//        longitude = (mapItem.placemark.location?.coordinate.longitude)!
//        streetNumber = mapItem.placemark.subThoroughfare
//        streetName = mapItem.placemark.thoroughfare
//        city = mapItem.placemark.locality
//        pizzaLocation = (mapItem.placemark.location)!
//    }
//
//    func distanceFromLocation(pizzaLocation: CLLocation) -> Double {
//        return pizzaLocation.distanceFromLocation(self.pizzaLocation)
//    }
}


//    var name: String
//    var latitude: Double
//    var longitude: Double
//    var streetNumber: String?
//    var streetName: String?
//    var city: String?
//    var pizzaLocation: CLLocation
//
//    init(mapItem: MKMapItem) {
//
//        name = mapItem.name!
//        latitude = (mapItem.placemark.location?.coordinate.latitude)!
//        longitude = (mapItem.placemark.location?.coordinate.longitude)!
//        streetNumber = mapItem.placemark.subThoroughfare
//        streetName = mapItem.placemark.thoroughfare
//        city = mapItem.placemark.locality
//        pizzaLocation = (mapItem.placemark.location)!
//    }
//
//    func distanceFromLocation(pizzaLocation: CLLocation) -> Double {
//        return pizzaLocation.distanceFromLocation(self.pizzaLocation)
//    }






//    var coffeePlaceName = String()
//    var distanceFromCurrentLocation = Double()
//    var coffeePlaceCoordinates = CLLocationCoordinate2D()
//
//    init(userLocation: CLLocation, coffeePlace: CLPlacemark) {
//
//        distanceFromCurrentLocation = (userLocation.distanceFromLocation(coffeePlace.location!)) / 1609.34
//        coffeePlaceName = coffeePlace.name!
//        coffeePlaceCoordinates = (coffeePlace.location?.coordinate)!
////    }
//
//    init() {
//        
//    }
//
//    init(mapItem: MKMapItem, milesDifference: Double) {
//
//        self.mapItem = mapItem
//        self.milesDifference = milesDifference
//        
//    }
//}

