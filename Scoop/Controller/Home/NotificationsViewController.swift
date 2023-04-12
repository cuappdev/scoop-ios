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
    private var pendingRequests: [RideRequest] = []
    private var respondedRequests: [RideRequest] = []
    private var allRequests: [RideRequest] = []
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)!]
        self.navigationItem.title = "Notifications"
        
        // MARK: Still needs to be debugged after backend confirmation
        getRequests()
        // MARK: Used for building views
//        allRequests = [Constants.defaultTRequest, Constants.defaultFRequest]
        setupTableView()
    }
    
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
        tableView.separatorStyle = .singleLine
        tableView.contentInsetAdjustmentBehavior = .never
        // Not sure about this, it makes the entire cell layout shift. Not sure how else to make the separator last the entire line though. 
//        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.register(RequestTableViewCell.self, forCellReuseIdentifier: requestCellIdentifier)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func getRequests() {
        NetworkManager.shared.getAllRequests { [weak self] response in
            switch response {
            case .success(let response):
                guard let strongSelf = self else { return }
                strongSelf.pendingRequests = response.waitingApproval
                strongSelf.respondedRequests = response.toApprove
                strongSelf.allRequests = strongSelf.pendingRequests + strongSelf.respondedRequests
            case .failure(let error):
                print("Unable to get all rides: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: UITableViewDelegate
extension NotificationsViewController: UITableViewDelegate {
    // Will be used later for updating what the cell looks like when a user hits accept/decline
}

// MARK: UITableViewDataSource
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
        if let approved =  allRequests[indexPath.row].approved {
            if approved {
                return 100
            } else {
                return 110
            }
        }
        return 100
    }
    
}
