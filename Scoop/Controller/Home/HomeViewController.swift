//
//  HomeViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 2/23/22.
//

import GoogleSignIn
import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Views
    private var headerView = UIImageView()
    private let postRideButton = UIButton()
    private let signOutButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: Identifers
    private let homeCellIdenitifer = "HomeCell"
    
    private enum TableSection: String, CaseIterable {
        case activeTrips = "Active Trips"
        case pendingTrips = "Pending Trips"
    }
    
    // MARK: Data
    private var activeRides = [Ride]()
    private var pendingRides = [Ride]()
    
    // MARK: Networking
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupTableView()
        setupPostRideButton()
        
        getRides()
        // Commented out currently because signing out functionality is not yet implemented
        //        setupSignOutButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupHeaderView() {
        headerView = UIImageView(image: UIImage(named: "Logo"))
        headerView.contentMode = .scaleAspectFit
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(90)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupPostRideButton() {
        postRideButton.setImage(UIImage(systemName: "car.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 28)), for: .normal)
        postRideButton.backgroundColor = .white
        postRideButton.layer.shadowColor = UIColor.black.cgColor
        postRideButton.layer.shadowOpacity = 0.25
        postRideButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        postRideButton.layer.shadowRadius = 4
        postRideButton.layer.masksToBounds = false
        postRideButton.layer.cornerRadius = 35
        postRideButton.tintColor = .scoopGreen
        postRideButton.layer.borderWidth = 3
        postRideButton.layer.borderColor = UIColor.scoopGreen.cgColor
        view.addSubview(postRideButton)
        
        postRideButton.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        let postRideAction = UIAction { _ in
            let postRideLocationVC = PostRideLocationViewController()
            postRideLocationVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(postRideLocationVC, animated: true)
        }
        
        postRideButton.addAction(postRideAction, for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: homeCellIdenitifer)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(signOutButton)
        
        signOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let signOutAction = UIAction { _ in
            self.signOut()
        }
        
        signOutButton.addAction(signOutAction, for: .touchUpInside)
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        dismiss(animated: true)
    }
    
    private func getRides() {
        networkManager.getAllRides { RideResponse in
            for ride in RideResponse.rides {
                // Note: Technically need to split this into pending + active rides but for some reason the new Ride
                // model does not have something for it so will fix this asap after backend models are confirmed
                self.activeRides.append(ride)
            }
        }
        // Keeping dummy data here so UI work can be done if needed when networking is still not yet finished
        // Populate table view with dummy data
        //        let readesRide = Ride()
        //        readesRide.creator.name = "Reade"
        //        readesRide.departureLocation = "Ithaca, NY"
        //        readesRide.arrivalLocation = "Darien, CT"
        //        readesRide.date = "Mar
        //        readesRide.isActive
        //        let annesRide =
        //        annesRide.creator.name = "
        //        annesRide.departureLocation = "Ithaca,
        //        annesRide.arrivalLocation = "Orlando,
        //        annesRide.date = "Apr
        //        annesRide.isActive
        //        let karlsRide =
        //        karlsRide.creator.name = "
        //        karlsRide.departureLocation = "Ithaca,
        //        karlsRide.arrivalLocation = "Pittsburgh,
        //        karlsRide.date = "May
        //        karlsRide.isActive
        //        let sarahsRide =
        //        sarahsRide.creator.name = "
        //        sarahsRide.departureLocation = "Ithaca,
        //        sarahsRide.arrivalLocation = "Montreal,
        //        sarahsRide.date = "May
        //        sarahsRide.isActive
        //        activeRides = [readesRide,
        //        pendingRides = [karlsRide, sarahsRide]
    }
    
}
                
            
        


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return TableSection.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeTableViewHeader()
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        headerView.configure(title: title)
        return headerView
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TableSection.allCases[section] {
        case .activeTrips:
            return activeRides.count
        case .pendingTrips:
            return pendingRides.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: homeCellIdenitifer) as! HomeTableViewCell
        
        switch TableSection.allCases[indexPath.section] {
        case .activeTrips:
            cell.configure(ride: activeRides[indexPath.row])
        case .pendingTrips:
            cell.configure(ride: pendingRides[indexPath.row])
        }
        
        return cell
    }
    
    
}
