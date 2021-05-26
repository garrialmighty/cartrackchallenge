//
//  CarViewController.swift
//  CartrackChallenge
//
//  Created by Garri Adrian Nablo on 5/24/21.
//

import UIKit

final class CarViewController: UISplitViewController {
    
    private var listVC: CarListTableViewController!
    private var detailsVC: CarDetailViewController!
    let viewModel = CarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        var primaryVC: UIViewController?
        var secondaryVC: UIViewController?

        let masterNavController = viewControllers.first as? UINavigationController
        primaryVC = masterNavController?.viewControllers.first
        
        // in iOS 13 UISplitViewController returns a UINavigationController container for both master and detail
        // in iOS 12 only master is contained in a UINavigationController
        // TODO: use viewController(for:) introduced in iOS 14 
        if #available(iOS 13, *) {
            let detailNavController = viewControllers.last as? UINavigationController
            secondaryVC = detailNavController?.topViewController
        } else {
            secondaryVC = viewControllers.last
        }
        
        guard let listVC = primaryVC as? CarListTableViewController,
              let detailsVC = secondaryVC as? CarDetailViewController else { return }
        
        listVC.delegate = self
        self.listVC = listVC
        self.detailsVC = detailsVC
    }
}

// MARK: - CarListTableViewControllerDelegate
extension CarViewController: CarListTableViewControllerDelegate {
    func carListView(_ view: CarListTableViewController, didSelect car: Car) {
        detailsVC.viewModel = CarDetailViewModel(car: car)
        
        if #available(iOS 14.0, *) {
            show(.secondary)
        } else {
            showDetailViewController(detailsVC, sender: nil)
        }
    }
    
    func carListViewDidLogout() {
        viewModel.logout()
    }
}
