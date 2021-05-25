//
//  CarListTableViewController.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import UIKit

protocol CarListTableViewControllerDelegate: AnyObject {
    func carListView(_ view: CarListTableViewController, didSelect car: Car)
    func carListViewDidLogout()
}

final class CarListTableViewController: UITableViewController {
    
    var viewModel = CarListViewModel()
    weak var delegate: CarListTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.fetchCars()
    }
    
    @IBAction private func logout(_ sender: UIBarButtonItem) {
        delegate?.carListViewDidLogout()
    }
}

// MARK: - UITableViewDelegate
extension CarListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.carListView(self, didSelect: viewModel.cars[indexPath.item])
    }
}

// MARK: - UITableViewDataSource
extension CarListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
        
        guard let carCell = cell as? CarTableViewCell else { return cell }
        
        carCell.configure(for: viewModel.cars[indexPath.item])
        return carCell
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension CarListTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let indexToShow = indexPaths.first?.item else { return }
        
        // fetch the next page if the user has scrolled past half the list of available cars
        if indexToShow > (viewModel.cars.count / 2) {
            viewModel.fetchMoreCars()
        }
    }
}

// MARK: - CarListViewModelDelegate
extension CarListTableViewController: CarListViewModelDelegate {
    func carListViewModel(_ viewModel: CarListViewModel, didFetchCars cars: [Car]) {
        tableView.reloadData()
    }
}
