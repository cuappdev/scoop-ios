//
//  SearchInitialViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/10/22.
//

import UIKit
import GooglePlaces

protocol SearchInitialViewControllerDelegate: AnyObject {
    func didSelectLocation(viewController: UIViewController, location: GMSPlace)
}

class SearchInitialViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    weak var delegate: SearchInitialViewControllerDelegate?
    
    private var locationController: LocationViewController!
    private var searchController = UISearchController()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        locationController.filterText(searchText: searchText)
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationController = LocationViewController(searchController: self, delegate: self)
        setupSearchController()
    }
    
    // MARK: - Setup Search Controller
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: locationController)
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - LocationViewControllerDelegate

extension SearchInitialViewController: LocationViewControllerDelegate {
    
    func didSelectLocation(location: GMSPlace) {
        delegate?.didSelectLocation(viewController: self, location: location)
    }
    
}
