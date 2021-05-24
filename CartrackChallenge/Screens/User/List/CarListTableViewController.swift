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
