//
//  MapViewController.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/14/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var mapCoffeeArray = [CoffeePlace]()
    
    @IBOutlet var mapView2: MKMapView!

    var curLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView2.showsUserLocation = true

        for mapCoffee in mapCoffeeArray {
            print(mapCoffee.name)
        }
    }

    override func viewDidAppear(animated: Bool) {

        centerMapOnLocation(curLocation)
        addCoffeePlacesToMap()
    }

    func addCoffeePlacesToMap() {

        for coffeePlace in self.mapCoffeeArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coffeePlace.location.coordinate
            annotation.title = coffeePlace.name
            self.mapView2.addAnnotation(annotation)
        }
    }

    func centerMapOnLocation(location: CLLocation) {

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView2.setRegion(coordinateRegion, animated: true)
    }


}
