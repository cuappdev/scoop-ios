//
//  NotificationsViewController.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/7/23.
//

import Foundation
import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: Views
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let backButton = UIButton()
    
    // MARK: Identifiers
    private let requestCellIdentifier = "RequestCell"
    
    // MARK: Data
    private var requests: [RequestResponse] = [RequestResponse(id: 1, approvee: NetworkManager.shared.currentUser, approver: NetworkManager.shared.currentUser, ride: Ride(id: 0, creator: BaseUser(id: 0, netid: "", firstName: "", lastName: "", profilePicUrl: "", grade: "", pronouns: ""), maxTravelers: 0, minTravelers: 0, departureDatetime: "", isFlexible: true, path: Path(id: 0, startLocationPlaceId: "", startLocationName: "", endLocationPlaceId: "", endLocationName: ""), type: "") , approved: false), RequestResponse(id: 1, approvee: NetworkManager.shared.currentUser, approver: NetworkManager.shared.currentUser, ride: Ride(id: 0, creator: BaseUser(id: 0, netid: "", firstName: "", lastName: "", profilePicUrl: "", grade: "", pronouns: ""), maxTravelers: 0, minTravelers: 0, departureDatetime: "", isFlexible: true, path: Path(id: 0, startLocationPlaceId: "", startLocationName: "", endLocationPlaceId: "", endLocationName: ""), type: "") , approved: false)]
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)!]
        self.navigationItem.title = "Notifications"
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        setupBackButton()
        setupTableView()
    }
    
    private func setupBackButton() {
        backButton.setImage(UIImage(named: "BackArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorColor = .systemGray
        tableView.separatorStyle = .singleLine
        // Not sure about this, it makes the entire cell layout shift. Not sure how else to make the separator last the entire line though. 
//        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.register(RequestTableViewCell.self, forCellReuseIdentifier: requestCellIdentifier)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-35)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func popVC() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    // Will be used later for updating what the cell looks like when a user hits accept/decline
}

// MARK: UITableViewDataSource
extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: requestCellIdentifier) as! RequestTableViewCell
        if requests[indexPath.row].approved {
            cell.configure(request: requests[indexPath.row], status: true)
        } else {
            cell.configure(request: requests[indexPath.row], status: false)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Make this dynamic. Works ok for now, but .automaticDimension didn't really work.
        requests[indexPath.row].approved ? 100 : 110
    }
    
}
