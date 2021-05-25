//
//  CarListViewModel.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import Foundation

protocol CarListViewModelDelegate: AnyObject {
    func carListViewModel(_ viewModel: CarListViewModel, didFetchCars cars: [Car])
}

final class CarListViewModel {
    
    var cars: [Car] = []
    weak var delegate: CarListViewModelDelegate?
    
    private var page = 1
    private let loader: CarLoader
    
    init(loader: CarLoader) {
        self.loader = loader
    }
    
    func fetchCars() {
        loader.fetchCars(page: 0) { [unowned self] result in
            switch result {
            case .success(let carsResult):
                cars = carsResult
                delegate?.carListViewModel(self, didFetchCars: carsResult)
            case .failure(_):
                // handle error if needed
                // silently fail for now
                break
            }
        }
    }
    
    func fetchMoreCars() {
        loader.fetchCars(page: page) { [unowned self] result in
            switch result {
            case .success(let carsResult):
                page += 1
                cars.append(contentsOf: carsResult)
                delegate?.carListViewModel(self, didFetchCars: carsResult)
            case .failure(_):
                // handle error if needed
                // silently fail for now
                break
            }
        }
    }
}
