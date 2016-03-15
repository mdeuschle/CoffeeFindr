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

    var coffeeShopName = ""
    var streetNumber = ""
    var streetName = ""
    var fullStreetName = ""
    var coffeeShopLat = ""
    var coffeeShopLong = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView1.showsUserLocation = true

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


    func addCoffeePlacesToMap() {

        for coffeePlace in self.coffeeArray {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coffeePlace.location.coordinate

            if let coffeePlaceName = coffeePlace.name {

                annotation.title = coffeePlaceName
            }

            self.mapView1.addAnnotation(annotation)
        }
    }


    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {

        if let loc = userLocation.location {
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
        request.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 3000, 3000)
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

        if let coffeePlaceName = coffeePlace.name
        {
            coffeeShopName = coffeePlaceName
        }

        cell?.textLabel?.text = coffeeShopName


        if let coffeePlaceStreetNumber = coffeePlace.streetNumber {

            streetNumber = coffeePlaceStreetNumber
        }

        if let coffeePlaceStreetName = coffeePlace.streetName {

            streetName = coffeePlaceStreetName
        }

        fullStreetName = streetNumber + " " + streetName

        cell?.detailTextLabel?.text = fullStreetName

//        let miles = (coffeePlace.distanceFromLocation(self.currentLocation) * 0.000621371)
//        let coffeeMiles  = Double(round(10 * miles)/10)
//        
//        cell?.detailTextLabel?.text = "\(coffeeMiles) mi"

        return cell!
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let dvc = segue.destinationViewController as! MapViewController

        let mapCoffeeArray = self.coffeeArray
        dvc.mapCoffeeArray = mapCoffeeArray

        let curLocation = self.currentLocation
        dvc.curLocation = curLocation

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let coffeePlace = self.coffeeArray[indexPath.row]

        coffeeShopLat = String(coffeePlace.latitude)

        coffeeShopLong = String(coffeePlace.longitude)

        UIApplication.sharedApplication().openURL(NSURL(string: "http://maps.apple.com/maps?daddr=\(coffeeShopLat),\(coffeeShopLong)")!)
    }
    
}
