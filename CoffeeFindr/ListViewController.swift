//
//  ListViewController.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/11/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var coffeeTableView: UITableView!

    var coffeeArray = [CoffeePlace]()
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation()

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }

    func findCoffeePlaces(location: CLLocation) {

        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "Coffee"

                request.region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000)
//        request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1))
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (response: MKLocalSearchResponse?, error: NSError?) -> Void in

            let mapItems = response?.mapItems

            self.coffeeArray = (mapItems?.map({ CoffeePlace(mapItem: $0) }))!
            self.coffeeArray.sortInPlace({ (coffee1, coffee2) -> Bool in
                coffee1.distanceFromLocation(self.currentLocation) < coffee2   .distanceFromLocation(self.currentLocation)
            })

            self.coffeeTableView.reloadData()
        }
    }



    //            let mapItems = response?.mapItems
    //            self.pizzaPlaces = (mapItems?.map({ PizzaPlace(mapItem: $0) }))!
    //            self.pizzaPlaces.sortInPlace({ (pizza1, pizza2) -> Bool in
    //                pizza1.distanceFromLocation(self.userLocation) < pizza2.distanceFromLocation(self.userLocation)
    //            })
    //
    //            for item in mapItems! {
    //
    //                let coffeeShop = CoffeePlace(mapItem: item)
    //                self.coffeeArray.append(coffeeShop)
    //            }
    //            self.coffeeTableView.reloadData()
    //
    //        }
    //    }

    ////                self.coffeePlacesArray.append(mapItem)
    //                self.coffeeTableView.reloadData()
    //
    //                let metersAway = mapItem.placemark.location?.distanceFromLocation(location)
    //                let milesDifference = metersAway! / 1609.34
    //
    //                let coffeePlace = CoffeePlace()
    //                coffeePlace.mapItem = mapItem
    //                coffeePlace.milesDifference = (milesDifference)
    //                temporaryArray.append(coffeePlace)
    //
    //
    ////            let sortDescriptor : NSSortDescriptor = NSSortDescriptor(key: "milesDifference", ascending: true)
    ////            let sortedArray = (temporaryArray as NSArray).sortedArrayUsingDescriptors([sortDescriptor])
    ////            self.coffeePlacesArray = NSArray(array: sortedArray) as [AnyObject]


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
        let coffeeMiles  = Double(round(100 * miles)/100)

        cell?.detailTextLabel?.text = "\(coffeeMiles) mi"

        return cell!
    }
}
