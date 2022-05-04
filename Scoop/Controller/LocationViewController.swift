//
//  LocationViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/27/22.
//

import UIKit

protocol LocationViewControllerDelegate: AnyObject {
    func didSelectLocation(location: String)
}

class LocationViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let cellHeight: CGFloat = 50
    private var filteredLocations: [String] = []
    private var locations: [String] = []
    weak var delegate: LocationViewControllerDelegate?
    
    private var searchController: SearchInitialViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    init(searchController: SearchInitialViewController, delegate: LocationViewControllerDelegate) {
        self.searchController = searchController
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        locations = ["Ithaca, NY", "Duffield Hall", "Gates Hall", "Klarman Hall", "Roselle Park, NJ", "Albany, NY", "Cupertino, CA", "Cayuga Lake, NY", "Rhodes Hall, NY"]
        filteredLocations = locations
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview()
        }
    }
    
    func filterText(searchText: String) {
        filteredLocations = locations.filter { loc in
            if(!searchText.isEmpty) {
                let searchTextMatch = loc.lowercased().contains(searchText.lowercased())
                return searchTextMatch
            }
            else {
                return true
            }
        }
        tableView.reloadData()
    }
    
}
// MARK: - UITableViewDataSource
extension LocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell {
            let location = filteredLocations[indexPath.row]
            cell.configure(location: location)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
// MARK: - UITableViewDelegate
extension LocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLocation(location: filteredLocations[indexPath.row])
        searchController.navigationController?.popViewController(animated: true)
    }
    
}
