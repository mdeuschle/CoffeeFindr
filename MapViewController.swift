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
    var streetName = ""
    var streetNumber = ""
    var fullStreetName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Coffee Findr"

        mapView2.showsUserLocation = true

        addCoffeePlacesToMap()
        centerMapOnLocation(curLocation)
    }

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation.isEqual(mapView.userLocation) {
            return nil
        }

        let reuseIdentifier = "pin"

        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier) as? MKPinAnnotationView

        if pin == nil {

            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            pin!.canShowCallout = true
            pin!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)

        } else {

            pin!.annotation = annotation
        }

        return pin
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl) {

            let selectedLoc = view.annotation
            let currentLocMapItem = MKMapItem.mapItemForCurrentLocation()
            let selectedPlacemark = MKPlacemark(coordinate: selectedLoc!.coordinate, addressDictionary: nil)
            let selectedMapItem = MKMapItem(placemark: selectedPlacemark)
            let mapItems = [selectedMapItem, currentLocMapItem]
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            MKMapItem.openMapsWithItems(mapItems, launchOptions:launchOptions)
    }

    func addCoffeePlacesToMap() {

        for coffeePlace in self.mapCoffeeArray {

            let annotation = MKPointAnnotation()
            annotation.coordinate = coffeePlace.location.coordinate
            if let coffeePlaceName = coffeePlace.name {

                annotation.title = coffeePlaceName
            }
            if let stNumber = coffeePlace.streetNumber {

                streetNumber = stNumber
            }
            if let stName = coffeePlace.streetName {

                streetName = stName
            }
            annotation.subtitle = streetNumber + " " + streetName
            self.mapView2.addAnnotation(annotation)
        }
    }

    func centerMapOnLocation(location: CLLocation) {

        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2800, 2800)
        mapView2.setRegion(coordinateRegion, animated: true)
    }
}


