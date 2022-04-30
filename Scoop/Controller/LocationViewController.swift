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
    
    private var tableView = UITableView()
    private var locations:[String] = []
    private var filteredLocations:[String] = []
    private let reuseIdentifier = "locationCellReuse"
    private let cellHeight: CGFloat = 50
    
    weak var delegate: LocationViewControllerDelegate?
    
    private var searchController: SearchInitialViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    init(searchController: SearchInitialViewController) {
        super.init(nibName: nil, bundle: nil)
        self.searchController = searchController
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        locations = ["Ithaca, NY", "Duffield Hall", "Gates Hall", "Klarman Hall", "Roselle Park, NJ", "Albany, NY", "Cupertino, CA", "Cayuga Lake, NY", "Rhodes Hall, NY"]
        filteredLocations = locations
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview()
        }
    }
    
    func filterText(searchText: String) {
        filteredLocations = locations.filter {
            loc in
            if(searchText != "") {
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

extension LocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? LocationTableViewCell {
            let location = filteredLocations[indexPath.row]
            cell.configure(location: location)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension LocationViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectLocation(location: filteredLocations[indexPath.row])
        searchController.navigationController?.popViewController(animated: true)
    }
}
