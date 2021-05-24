//
//  UserDetailViewController.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import UIKit
import MapKit
import CoreLocation

final class CarDetailViewController: UIViewController {
    
    @IBOutlet private  weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    private let locationManager = CLLocationManager()
    
    var viewModel = CarDetailViewModel() {
        didSet {
            updateUI()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func updateUI() {
        nameLabel.text = viewModel.car.name
        usernameLabel.text = viewModel.car.username
        emailLabel.text = viewModel.car.email
        
        // clear all pins
        mapView.annotations.forEach {
            mapView.removeAnnotation($0)
        }
        
        let pin = MKPlacemark(coordinate: viewModel.car.locationCoordinate)
        mapView.addAnnotation(pin)
        
        let userPin = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        mapView.showAnnotations([pin, userPin], animated: false)
        
        // remove user pin since we only use it to zoom out the map
        // so that both car pin and user location are visible
        mapView.removeAnnotation(userPin)
    }
}
