//
//  MapViewController.swift
//  CoffeeFindr
//
//  Created by Matt Deuschle on 3/14/16.
//  Copyright © 2016 Matt Deuschle. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    var mapCoffeeArray = [CoffeePlace]()
    
    @IBOutlet var mapView2: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        for mapCoffee in mapCoffeeArray {
            print(mapCoffee.name)
        }

    }


}
