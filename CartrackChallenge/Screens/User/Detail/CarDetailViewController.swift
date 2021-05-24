//
//  UserDetailViewController.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import UIKit
import MapKit

final class CarDetailViewController: UIViewController {
    
    @IBOutlet private  weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var mapView: MKMapView!
    
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
    }
}

// MARK: - Private
extension CarDetailViewController {
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
        
        // TODO: update as user moves
        let userPin = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        mapView.addAnnotation(userPin)
        mapView.showAnnotations([pin, userPin], animated: false)
    }
}
