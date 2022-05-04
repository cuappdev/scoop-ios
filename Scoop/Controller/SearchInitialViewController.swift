//
//  SearchInitialViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/10/22.
//

import UIKit

protocol SearchInitialViewControllerDelegate: AnyObject {
    func didSelectLocation(viewController: UIViewController, location: String)
}

class SearchInitialViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    weak var delegate: SearchInitialViewControllerDelegate?
    
    private var locationController: LocationViewController!
    private var searchController = UISearchController()
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        locationController.filterText(searchText: searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationController = LocationViewController(searchController: self, delegate: self)
        setupSearchController()
    }
    
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: locationController)
        navigationItem.searchController = searchController
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        navigationItem.searchController = searchController
    }
}

// MARK: - LocationViewControllerDelegate
extension SearchInitialViewController: LocationViewControllerDelegate {
    
    func didSelectLocation(location: String) {
        delegate?.didSelectLocation(viewController: self, location: location)
    }
    
}
