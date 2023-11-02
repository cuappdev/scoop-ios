//
//  HomeViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 2/23/22.
//

import GoogleSignIn
import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Views
    
    private var headerView = UIImageView()
    private let postRideButton = UIButton()
    private let signOutButton = UIButton()
    private let notificationButton = UIButton()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Empty State Views
    
    private let noTripsLabel = UILabel()
    private let searchButton = UILabel()
    private let secondLabel = UILabel()
    private let widePostRideButton = UIButton()
    
    // MARK: - Identifiers
    
    private let homeCellIdenitifer = "HomeCell"
    
    weak var postDelegate: PostRideSummaryDelegate?
    
    private enum TableSection: String, CaseIterable {
        case activeTrips = "ACTIVE TRIPS"
        case pendingTrips = "PENDING TRIPS"
    }
    
    // MARK: - Data
    
    private var activeRides = [HomeVCRide]()
    private var pendingRides = [HomeVCRide]()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupHeaderView()
        setupNotificationButton()
        setupRefreshControl()
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
    
    // MARK: - Setup View Functions
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData(refreshControl: UIRefreshControl) {
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
            postRideLocationVC.postDelegate = self
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
    
    private func setupNoTripsLabel() {
        noTripsLabel.text = "No trips yet"
        noTripsLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        view.addSubview(noTripsLabel)
        
        noTripsLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(180)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupSecondLabel() {
        secondLabel.text = "Find other travelers by posting a trip or searching for an existing trip"
        secondLabel.font = .systemFont(ofSize: 16, weight: .regular)
        secondLabel.textColor = UIColor.scooped.labelGray
        secondLabel.numberOfLines = 0
        secondLabel.lineBreakMode = .byWordWrapping
        secondLabel.textAlignment = .center
        view.addSubview(secondLabel)
        
        secondLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(noTripsLabel.snp.bottom).offset(16)
            make.width.equalTo(330)
        }
    }
    
    private func setupWidePostRideButton() {
        widePostRideButton.setAttributedTitle(NSMutableAttributedString(string: "Post trip", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]), for: .normal)
        widePostRideButton.setTitleColor(.white, for: .normal)
        widePostRideButton.layer.cornerRadius = 25
        widePostRideButton.backgroundColor = UIColor.scooped.scoopDarkGreen
        view.addSubview(widePostRideButton)
        
        widePostRideButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondLabel.snp.bottom).offset(24)
            make.width.equalTo(296)
            make.height.equalTo(50)
        }
        
        widePostRideButton.addTarget(self, action: #selector(postRideAction), for: .touchUpInside)
    }
    
    private func setupSearchButton() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        searchButton.attributedText = NSAttributedString(string: "Search for trips", attributes: underlineAttribute)
        searchButton.font = .systemFont(ofSize: 16, weight: .bold)
        searchButton.textColor = UIColor.scooped.scoopDarkGreen
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(launchSearch))
        searchButton.isUserInteractionEnabled = true
        searchButton.addGestureRecognizer(tapGesture)
        
        view.addSubview(searchButton)
        
        searchButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(widePostRideButton.snp.bottom).offset(28)
        }
    }
    
    private func setupEmptyState() {
        setupNoTripsLabel()
        setupSecondLabel()
        setupWidePostRideButton()
        setupSearchButton()
    }
    
    // MARK: - Helper Functions
    
    @objc private func postRideAction() {
        let postRideLocationVC = PostRideContainerViewController()
        postRideLocationVC.postDelegate = self
        postRideLocationVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(postRideLocationVC, animated: true)
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
            dateFormatterPrint.dateFormat = "MMM d"
            
            if let date = dateFormatterGet.date(from: ride.departureDatetime) {
                rideCopy.departureDatetime = dateFormatterPrint.string(from: date)
            }
            
            activeRides.append(rideCopy)
        })
    }
    
    private func updatePendingRides(requests: [RideRequest]) {
        pendingRides = []
        requests.forEach { request in
            if activeRides.contains(where: { ride in
                ride == request.ride
            }) {
                return
            } else {
                var rideCopy = request.ride
                
                // Source: https://stackoverflow.com/questions/35700281/date-format-in-swift
                let dateFormatterGet = DateFormatter()
                dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "MMM d"
                
                if let date = dateFormatterGet.date(from: request.ride.departureDatetime) {
                    rideCopy.departureDatetime = dateFormatterPrint.string(from: date)
                }
                
                pendingRides.append(rideCopy)
            }
        }
    }
    
    private func getRides() {
        // MARK: NEEDS TO BE UDPATED ONCE BACKEND CHANGES THE RIDE MODEL TO THE FULL ONE
        NetworkManager.shared.getUser { [weak self] response in
            switch response {
            case .success(let user):
                guard let strongSelf = self else { return }
                print("after guard let")
                strongSelf.updateActiveRides(rides: user.rides)
                if strongSelf.activeRides.isEmpty && strongSelf.pendingRides.isEmpty {
                    strongSelf.tableView.isHidden = true
                    strongSelf.setupEmptyState()
                } else {
                    DispatchQueue.main.async {
                        strongSelf.removeEmptyState()
                        strongSelf.tableView.isHidden = false
                        strongSelf.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Unable to get user: \(error.localizedDescription)")
            }
        }
        
        NetworkManager.shared.getAllRequests { [weak self] response in
            switch response {
            case .success(let requests):
                guard let strongSelf = self else { return }
                strongSelf.updatePendingRides(requests: requests.pendingRequests)
                if strongSelf.activeRides.isEmpty && strongSelf.pendingRides.isEmpty {
                    strongSelf.tableView.isHidden = true
                    strongSelf.setupEmptyState()
                } else {
                    DispatchQueue.main.async {
                        strongSelf.removeEmptyState()
                        strongSelf.tableView.isHidden = false
                        strongSelf.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print("Unable to get user: \(error.localizedDescription)")
            }
        }
    }
    
    private func removeEmptyState() {
        noTripsLabel.isHidden = true
        searchButton.isHidden = true
        secondLabel.isHidden = true
        widePostRideButton.isHidden = true
    }
    
    @objc private func launchSearch() {
        tabBarController?.selectedIndex = 1
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
            let fullRide = Ride(id: 0, creator: BaseUser(id: driver.id, netid: driver.netid, firstName: driver.firstName, lastName: driver.lastName, profilePicUrl: driver.profilePicUrl, grade: driver.grade, pronouns: driver.pronouns, prompts: driver.prompts, rides: []), maxTravelers: currentRide.maxTravelers, minTravelers: currentRide.minTravelers, departureDatetime: currentRide.departureDatetime, description: currentRide.description, isFlexible: true, path: currentRide.path, type: currentRide.type)
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

// MARK: - PostRideSummaryDelegate

extension HomeViewController: PostRideSummaryDelegate {
    
    func didPostRide() {
        getRides()
    }
    
}
