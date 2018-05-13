//
//  LocationManager.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 11/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private override init() { }
    
    private let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    weak var delegate: LocationManagerDelegate?
    
    func requestForAuthorization() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager didUpdateLocations : \(locations)")
        self.currentLocation = locations.last
        self.delegate?.locationManager(manager, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError : \(error.localizedDescription)")
        self.delegate?.locationManager(manager, didFailWithError: error)
    }
}
