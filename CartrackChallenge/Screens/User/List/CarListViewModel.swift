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
    private var page = 0
    weak var delegate: CarListViewModelDelegate?
    
    func fetchCars() {
        ApiService.shared.fetchCars { [unowned self] result in
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
        ApiService.shared.fetchCars(page: page) { [unowned self] result in
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
