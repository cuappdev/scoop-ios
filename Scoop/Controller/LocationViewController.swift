//
//  LocationViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/27/22.
//

import UIKit
import GooglePlaces

protocol LocationViewControllerDelegate: AnyObject {
    func didSelectLocation(location: GMSPlace)
}

class LocationViewController: UIViewController {
    
    // MARK: - Views
    private let tableView = UITableView()
    private var tableDataSource = GMSAutocompleteTableDataSource()
    
    private let cellHeight: CGFloat = 50
    private var filteredLocations: [String] = []
    private var locations: [String] = []
    weak var delegate: LocationViewControllerDelegate?
    
    private var searchController: SearchInitialViewController!
    
    // MARK: - Initializers
    
    init(searchController: SearchInitialViewController, delegate: LocationViewControllerDelegate) {
        self.searchController = searchController
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableDataSource.delegate = self
        setupTableView()
    }
    
    // MARK: - Setup View Functions
    
    func setupTableView() {
        let filter = GMSAutocompleteFilter()
        filter.countries = ["US", "CA"]
        tableDataSource.autocompleteFilter = filter
        
        filteredLocations = locations
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.reuseIdentifier)
        tableView.dataSource = tableDataSource
        tableView.delegate = tableDataSource
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview()
        }
    }
    
    // MARK: - Helper Functions
    
    func filterText(searchText: String) {
        tableDataSource.sourceTextHasChanged(searchText)
    }
}

// MARK: - GMSAutocompleteTableDataSourceDelegate

extension LocationViewController: GMSAutocompleteTableDataSourceDelegate {
    func didUpdateAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didRequestAutocompletePredictions(for tableDataSource: GMSAutocompleteTableDataSource) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didAutocompleteWith place: GMSPlace) {
        delegate?.didSelectLocation(location: place)
        searchController.navigationController?.popViewController(animated: true)
    }
    
    func tableDataSource(_ tableDataSource: GMSAutocompleteTableDataSource, didFailAutocompleteWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}
