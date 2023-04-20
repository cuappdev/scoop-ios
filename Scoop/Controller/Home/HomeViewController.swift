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
    private let notificationButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: Identifers
    private let homeCellIdenitifer = "HomeCell"
    
    private enum TableSection: String, CaseIterable {
        case activeTrips = "ACTIVE TRIPS"
        case pendingTrips = "PENDING TRIPS"
    }
    
    // MARK: Data
    private var activeRides = [HomeVCRide]()
    private var pendingRides = [HomeVCRide]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHeaderView()
        setupTableView()
        setupPostRideButton()
        setupNotificationButton()
        setupRefreshControl()
        
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
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData(refreshControl: UIRefreshControl) {
        pendingRides = []
        getRides()
        refreshControl.endRefreshing()
    }
    
    private func setupHeaderView() {
        headerView = UIImageView(image: UIImage(named: "Logo"))
        headerView.contentMode = .scaleAspectFit
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(90)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupPostRideButton() {
        postRideButton.setImage(UIImage(named: "addride"), for: .normal)
        postRideButton.backgroundColor = .clear
        postRideButton.layer.shadowColor = UIColor.black.cgColor
        postRideButton.layer.shadowOpacity = 0.25
        postRideButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        postRideButton.layer.shadowRadius = 4
        postRideButton.layer.masksToBounds = false
        postRideButton.layer.cornerRadius = 35
        view.addSubview(postRideButton)
        
        postRideButton.snp.makeConstraints { make in
            make.size.equalTo(70)
            make.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        let postRideAction = UIAction { _ in
            let postRideLocationVC = PostRideContainerViewController()
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
    
    private func setupNotificationButton() {
        notificationButton.setImage(UIImage(named: "notifbutton"), for: .normal)
        view.addSubview(notificationButton)
        
        notificationButton.snp.makeConstraints { make in
            make.size.equalTo(45)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            make.trailing.equalToSuperview().inset(25)
        }

        let checkNotifications = UIAction { _ in
            let notificationsVC = NotificationsViewController()
            notificationsVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(notificationsVC, animated: true)
        }
        
        notificationButton.addAction(checkNotifications, for: .touchUpInside)
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        dismiss(animated: true)
    }
    
    private func updateActiveRides(rides: [HomeVCRide]) {
        activeRides = []
        rides.forEach({ ride in
            var rideCopy = ride
            
            // Source: https://stackoverflow.com/questions/35700281/date-format-in-swift
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd"
            
            if let date = dateFormatterGet.date(from: ride.departureDatetime) {
                rideCopy.departureDatetime = dateFormatterPrint.string(from: date)
            }
            
            activeRides.append(rideCopy)
        })
    }
    
    private func getRides() {
        // MARK: NEEDS TO BE UDPATED ONCE BACKEND CHANGES THE RIDE MODEL TO THE FULL ONE
        NetworkManager.shared.getUser { [weak self] response in
            switch response {
            case .success(let user):
                guard let strongSelf = self else { return }
                strongSelf.updateActiveRides(rides: user.rides)
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                }
            case .failure(let error):
                print("Unable to get user: \(error.localizedDescription)")
            }
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentRide: HomeVCRide
        if indexPath.section == 0 {
            currentRide = activeRides[indexPath.row]
        } else {
            currentRide = pendingRides[indexPath.row]
        }
        
        if let driver = currentRide.driver {
            let fullRide = Ride(id: 0, creator: BaseUser(id: driver.id, netid: driver.netid, firstName: driver.firstName, lastName: driver.lastName, prompts: [], rides: []), maxTravelers: currentRide.maxTravelers, minTravelers: currentRide.minTravelers, departureDatetime: currentRide.departureDatetime, description: currentRide.description, isFlexible: true, path: currentRide.path, type: currentRide.type)
            let tripDetailView = TripDetailsViewController(currentRide: fullRide)
            tripDetailView.hideRequestButton()
            tripDetailView.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(tripDetailView, animated: true)
        }
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
            let shortenedRide = activeRides[indexPath.row]
            if let driver = shortenedRide.driver {
                let fullRide = Ride(id: 0, creator: BaseUser(id: driver.id, netid: driver.netid, firstName: driver.firstName, lastName: driver.lastName, prompts: [], rides: []), maxTravelers: shortenedRide.maxTravelers, minTravelers: shortenedRide.minTravelers, departureDatetime: shortenedRide.departureDatetime, description: shortenedRide.description, isFlexible: true, path: shortenedRide.path, type: shortenedRide.type)
                cell.configure(ride: fullRide)
            }
        case .pendingTrips:
            let shortenedRide = pendingRides[indexPath.row]
            if let driver = shortenedRide.driver {
                let fullRide = Ride(id: 0, creator: BaseUser(id: driver.id, netid: driver.netid, firstName: driver.firstName, lastName: driver.lastName, prompts: [], rides: []), maxTravelers: shortenedRide.maxTravelers, minTravelers: shortenedRide.minTravelers, departureDatetime: shortenedRide.departureDatetime, description: shortenedRide.description, isFlexible: true, path: shortenedRide.path, type: shortenedRide.type)
                cell.configure(ride: fullRide)
            }
        }
        return cell
    }
    
}
