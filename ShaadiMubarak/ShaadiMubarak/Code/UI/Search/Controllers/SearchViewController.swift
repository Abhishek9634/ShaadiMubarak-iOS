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
    var address: String? {
        if let addressDictionary = self.mapItem.placemark.addressDictionary,
            let array = addressDictionary["FormattedAddressLines"] as? [Any] {
            let address = array.map { "\($0)" }.joined(separator: ",\n")
            return address
        }
        return nil
    }
    
    init(mapItem: MKMapItem, annotation: MKAnnotation) {
        self.mapItem = mapItem
        self.annotation = annotation
    }
}

class SearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    private let regionRadius: CLLocationDistance = 6000
    private var currentLocation: CLLocation? = LocationManager.shared.currentLocation
    private var cellItems: [PlaceItem] = []
    
    private struct Segue {
        static let placeDetail = "PlaceDetailViewControllerSegueID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setCurrentRegion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func myLocationAction(_ sender: Any) {
        self.setCurrentRegion()
    }
    
    @IBAction func searchAction(_ sender: Any) {
        guard let searchText = self.searchTextField.text else { return }
        self.searchPlaces(searchText: searchText)
        self.searchTextField.resignFirstResponder()
    }
    
    @IBAction func headerAction(_ sender: Any) {
        self.animateTableView()
    }
    
    private func animateTableView() {
        self.tableHeightConstraint.constant = (self.tableHeightConstraint.constant > 40) ? 40 : 240
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: MKMapViewDelegate {
    
    func setupView() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.searchTextField.delegate = self
    }
    
    // WILL SET USER CURRENT LOCATION AS REGION
    func setCurrentRegion() {
        guard let currentLocation = self.currentLocation else { return }
        let region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,
                                                        self.regionRadius,
                                                        self.regionRadius)
        self.mapView.setRegion(region, animated: true)
    }
    
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
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.cellItems = mapItems.map {
            let annotation = MKPointAnnotation()
            let placemark = $0.placemark
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality, let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            self.mapView.addAnnotation(annotation)
            return PlaceItem(mapItem: $0, annotation: annotation)
        }
        self.tableView.reloadData()
        if mapItems.count > 0 {
            self.animateTableView()
        }
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
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(model.mapItem.placemark.coordinate, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell") as! PlaceTableViewCell
        cell.delegate = self
        cell.item = self.cellItems[indexPath.row]
        return cell
    }
}

extension SearchViewController: PlaceTableViewCellDelegate {
    
    func openPlaceDetail(from cell: PlaceTableViewCell) {
        self.performSegue(withIdentifier: Segue.placeDetail, sender: cell.item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier, segue.destination, sender) {
        case (Segue.placeDetail?, let vc as PlaceDetailViewController, let model as PlaceItem):
            vc.viewModel = model
        default: break
        }
        super.prepare(for: segue, sender: sender)
    }
}

