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
    @IBOutlet weak var searchTextField: UITextField!
    
    private let regionRadius: CLLocationDistance = 1000
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
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
    
    @IBAction func searchAction(_ sender: Any) {
        guard let searchText = self.searchTextField.text else { return }
        self.searchPlaces(searchText: searchText)
        self.searchTextField.resignFirstResponder()
    }
}

extension SearchViewController {
    
    func setupView() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.searchTextField.delegate = self
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func searchPlaces(searchText: String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = self.mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            print("Search Response : \(String(describing: response))")
            print("Search API Error : \(error.debugDescription)")
            guard let response = response else { return }
            print("Map Items : \(response.mapItems)")
            self.setMarksAndAnnotations(mapItems: response.mapItems)
        }
    }
    
    func setMarksAndAnnotations(mapItems: [MKMapItem]) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        mapItems.forEach {
            let annotation = MKPointAnnotation()
            let placemark = $0.placemark
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality, let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            self.mapView.addAnnotation(annotation)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
}

