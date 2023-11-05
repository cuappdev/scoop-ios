//
//  NotificationsViewController.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/7/23.
//

import Foundation
import UIKit

class NotificationsViewController: UIViewController {
    
    // MARK: - Views

    private let backButton = UIButton()
    private let emptyStateView = EmptyStateView()
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    // MARK: - Identifiers
    
    private let requestCellIdentifier = "RequestCell"
    
    // MARK: - Data
    
    private var awaitingApproval: [RideRequest] = []
    private var pendingRequests: [RideRequest] = []
    private var allRequests: [RideRequest] = []
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)!]
        self.navigationItem.title = "Notifications"

        setupEmptyStateView()
        getRequests()
    }

    override func viewDidLayoutSubviews() {
        tableView.isHidden = allRequests.isEmpty
    }
    
    // MARK: - Setup View Functions
    
    private func setupBackButton() {
        backButton.setImage(UIImage(named: "BackArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(popVC), for: .touchUpInside)
        navigationController?.navigationBar.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorInset = .zero
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        tableView.separatorColor = .systemGray
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        tableView.register(RequestTableViewCell.self, forCellReuseIdentifier: requestCellIdentifier)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupEmptyStateView() {
        emptyStateView.setup(
            image: UIImage.scooped.notifIcon!,
            title: "No new notifications",
            subtitle: "You’re all caught up at the moment!"
        )
        view.addSubview(emptyStateView)

        emptyStateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Helper Functions
    
    private func getRequests() {
        NetworkManager.shared.getAllRequests { [weak self] response in
            switch response {
            case .success(let response):
                guard let strongSelf = self else { return }
                strongSelf.pendingRequests = response.pendingRequests
                strongSelf.awaitingApproval = response.awaitingApproval
                strongSelf.allRequests = strongSelf.pendingRequests + strongSelf.awaitingApproval
                strongSelf.setupTableView()
            case .failure(let error):
                print("Unable to get all requests: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDelegate

extension NotificationsViewController: UITableViewDelegate {
    // Will be used later for updating what the cell looks like when a user hits accept/decline
}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: requestCellIdentifier) as! RequestTableViewCell
        cell.configure(request: allRequests[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // TODO: Make this dynamic. Works ok for now, but .automaticDimension didn't really work.
        if let approved = allRequests[indexPath.row].approved {
            if NetworkManager.shared.currentUser.id == allRequests[indexPath.row].approver.id && !approved {
                return 110
            }
        }
        return 100
    }
    
}

