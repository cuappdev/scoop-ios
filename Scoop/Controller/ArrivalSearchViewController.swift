//
//  ArrivalSearchViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/21/22.
//

import UIKit

class ArrivalSearchViewController: SearchInitialViewController {
    
    // MARK: - Lifecycle Functions
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.searchController?.searchBar.placeholder = "Arrival location"
    }
    
}
