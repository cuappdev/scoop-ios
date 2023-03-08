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
    private let pendingCellIdentifier = "pendingCell"
    private let regularCellIdentifier = "decidedCell"
    
    // MARK: Data
    private var requests = [RequestResponse]()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)!]
        self.navigationItem.title = "Notifications"
        
        
    }
    
    
}
