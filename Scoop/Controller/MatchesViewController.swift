//
//  MatchesViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/27/22.
//

import UIKit

class MatchesViewController: UIViewController {
    // MARK: Views
    private let tableView = UITableView()
    
    // MARK: Identifiers
    private let homeCellIdenitifer = "HomeCell"
    
    var matchedRides: [Ride] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Best Matches"
        
        setupTableView()
    }
    
    init(rides: [Ride]) {
        super.init(nibName: nil, bundle: nil)
        self.matchedRides = rides
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellIdenitifer)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension MatchesViewController: UITableViewDelegate {
    
}

extension MatchesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        matchedRides.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdenitifer, for: indexPath) as! HomeTableViewCell
        cell.configure(ride: matchedRides[indexPath.row])
        return cell
    }
    
}
