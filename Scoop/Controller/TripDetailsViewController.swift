//
//  TripDetailsViewController.swift
//  Scoop
//
//  Created by Richie Sun on 2/22/23.
//

import UIKit

class TripDetailsViewController: UIViewController {
    
    var currentRide: Ride?
    
    private let stackView = UIStackView()
    private let creatorLabel = UILabel()
    private let creatorProfile = UIImageView()
    private let creatorEmail = UILabel()
    private let transportationMethod = UILabel()
    private let driverType = UILabel()
    private let locations = UILabel()
    private let arrivalLocationLabel = UILabel()
    private let departureLocationLabel = UILabel()
    private let departureDateLabel = UILabel()
    private let departureDate = UILabel()
    private let numberTravelersLabel = UILabel()
    private let numberTravelers = UILabel()
    private let detailsLabel = UILabel()
    private let detailsTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(NetworkManager.shared.currentUser.firstName)'s Ride"
        setUpStackView()
    }
    
    private func setUpStackView() {
        let stackViewMultiplier = 0.10
        let leadingTrailingInset = 20.0
        let spacing = 12.0
        let screenSize = UIScreen.main.bounds
        let labelFont = UIFont(name: "SFPro", size: 16)
        let textFieldFont = UIFont(name: "Rambla-Regular", size: 16)
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackViewMultiplier * screenSize.height)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        guard let creator = currentRide?.creator else { return }
        
        creatorLabel.text = creator.firstName
        stackView.addArrangedSubview(creatorLabel)
    }
}
