//
//  ListViewController.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/11/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var coffeeTableView: UITableView!
    @IBOutlet var mapView1: MKMapView!

    var coffeeArray = [CoffeePlace]()
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView1.delegate = self

        self.title = "Coffee Findr"

        // remove space on top of cell
        self.automaticallyAdjustsScrollViewInsets = false

        // remove tableview lines
        self.coffeeTableView.separatorColor = UIColor.clearColor()

        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    override func viewDidAppear(animated: Bool) {

        locationAuthStatus()
    }


    func addCoffeePlacesToMap () {

        for coffeePlace in self.coffeeArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coffeePlace.location.coordinate
            annotation.title = coffeePlace.name
            self.mapView1.addAnnotation(annotation)
        }
    }


    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        if let loc = userLocation.location {
//            centerMapOnLocation(loc)
            findCoffeePlaces(loc)
        }
    }

    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView1.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func findCoffeePlaces(location: CLLocation) {

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Coffee"
        request.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        mapView1.setRegion(request.region, animated: true)
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in

            let mapItems = response?.mapItems

            self.coffeeArray = (mapItems?.map({ CoffeePlace(mapItem: $0) }))!
            self.coffeeArray.sortInPlace({ (coffee1, coffee2) -> Bool in
                coffee1.distanceFromLocation(self.currentLocation) < coffee2   .distanceFromLocation(self.currentLocation)
            })
            self.coffeeTableView.reloadData()
            self.addCoffeePlacesToMap()
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if let location = locations.first {

            currentLocation = location
        }

        if currentLocation.verticalAccuracy < 1000 && currentLocation.horizontalAccuracy < 1000 {

            locationManager.stopUpdatingLocation()
            print("Current location is: \(currentLocation)")
            findCoffeePlaces(currentLocation)
        }
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager Error: \(error)")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.coffeeArray.count < 21 {

            return self.coffeeArray.count
        } else {

            return 20
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")

        let coffeePlace = self.coffeeArray[indexPath.row]
        cell?.textLabel?.text = coffeePlace.name
        
        let miles = (coffeePlace.distanceFromLocation(self.currentLocation) * 0.000621371)
        let coffeeMiles  = Double(round(10 * miles)/10)
        
        cell?.detailTextLabel?.text = "\(coffeeMiles) mi"

        return cell!
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let dvc = segue.destinationViewController as! MapViewController

        let mapCoffeeArray = self.coffeeArray

        dvc.mapCoffeeArray = mapCoffeeArray
        
    }
}
