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
    
    private var searchController = UISearchController()
    private var locationController: LocationViewController!
    
    weak var delegate: SearchInitialViewControllerDelegate?
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        
        locationController.filterText(searchText: searchText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        locationController = LocationViewController(searchController: self)
        locationController.delegate = self
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
