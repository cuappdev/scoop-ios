//
//  DepartureSearchViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/21/22.
//

import UIKit

class DepartureSearchViewController: SearchInitialViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.searchController?.searchBar.placeholder = "Departure location"
    }
    
}
