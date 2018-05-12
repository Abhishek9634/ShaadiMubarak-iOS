//
//  SearchViewController.swift
//  ShaadiMubarak
//
//  Created by Abhishek on 12/05/18.
//  Copyright © 2018 Abhishek. All rights reserved.
//

import UIKit
import MapKit

class PlaceItem {
    
    var mapItem: MKMapItem
    var annotation: MKAnnotation
    
    init(mapItem: MKMapItem, annotation: MKAnnotation) {
        self.mapItem = mapItem
        self.annotation = annotation
    }
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private let regionRadius: CLLocationDistance = 1000
    private var currentLocation: CLLocation?
    private var cellItems: [PlaceItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupTableView()
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
            self.populateCellModels(mapItems: response.mapItems)
        }
    }
    
    func populateCellModels(mapItems: [MKMapItem]) {
        self.cellItems = mapItems.map {
            let annotation = MKPointAnnotation()
            let placemark = $0.placemark
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality, let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \n \(state)"
            }
            self.mapView.addAnnotation(annotation)
            return PlaceItem(mapItem: $0, annotation: annotation)
        }
        self.tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: nil),
                                forCellReuseIdentifier: "PlaceTableViewCell")
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.cellItems[indexPath.row]
        self.mapView.selectAnnotation(model.annotation, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        cell.item = self.cellItems[indexPath.row]
        return cell
    }
}

