//
//  ArrivalSearchViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 4/21/22.
//

import UIKit

class ArrivalSearchViewController: SearchInitialViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.searchController?.searchBar.placeholder = "Arrival location"
    }
    
}
