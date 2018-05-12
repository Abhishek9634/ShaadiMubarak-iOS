//
//  SearchViewController.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 12/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let regionRadius: CLLocationDistance = 1000
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupMapView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func myLocationAction(_ sender: Any) {
        guard let currentLocation = self.currentLocation else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,
                                                                  self.regionRadius,
                                                                  self.regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension SearchViewController {
    
    func setupMapView() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }
}

extension SearchViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        self.currentLocation = userLocation.location
        
        // TEST
        //        self.reverseGeoCoding(location: userLocation.location!)
    }
    
    func reverseGeoCoding(location: CLLocation) {
        
        let geocoder = CLGeocoder()
        //        let userLocation = self.mapView.userLocation.location // get directly from map
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if let error = error {
                print("Geo Coding Error: \(error.localizedDescription)")
                return
            }
            
            guard let placemarks = placemarks,
                let firstPlacemark = placemarks.first,
                let addressDictionary = firstPlacemark.addressDictionary else { return }
            //            let street = addressDictionary["Street"]
            //            let city = addressDictionary["City"]
            //            let state = addressDictionary["State"]
            //            let zip = addressDictionary["ZIP"]
            print(addressDictionary.description)
            if let array = addressDictionary["FormattedAddressLines"] as? [Any] {
                let address = array.map { "\($0)" }.joined(separator: ",\n")
                print("Address : \(address)")
            }
            
        }
        
    }
}
