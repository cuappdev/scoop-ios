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
    private let requestButton = UIButton()
    
    private let mailIcon = UIImageView(image: UIImage(named: "mailIcon"))
    private let carIcon = UIImageView(image: UIImage(named: "carIcon"))
    private let departureIcon = UIImageView(image: UIImage(named: "locationIcon"))
    private let arrivalIcon = UIImageView(image: UIImage(named: "destinationIcon"))
    private let calendarIcon = UIImageView(image: UIImage(named: "calendarIcon"))
    private let iconSeperator = UIImageView(image: UIImage(named: "iconSeperator"))
    
    private let driverInfoContainerView = UIView()
    private let transportationContainerView = UIView()
    private let locationsContainerView = UIView()
    private let dateContainerView = UIView()
    private let numberTravelersContainerView = UIView()
    private let detailsContainerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Messy Data will be replaced once backend is finished
        currentRide = Ride(id: 0, creator: BaseUser(id: 0, netid: "rs929", firstName: "Richie", lastName: "Sun", profilePicUrl: "", grade: "Sophomore", pronouns: "He/Him"), maxTravelers: 2, minTravelers: 1, departureDatetime: "11/22/2022 @3:00 PM", isFlexible: true, path: Path(id: 0, startLocationPlaceId: "id", startLocationName: "Ithaca, NY", endLocationPlaceId: "id2", endLocationName: "New York, NY"), type: "Student Driver")
        
        view.backgroundColor = .white
        navigationItem.title = "\(NetworkManager.shared.currentUser.firstName)'s Ride" //TODO: Change to selected ride driver
        setUpStackView()
        setUpButton()
        setUpLabelFont()
        setUpTextFont()
        setUpIcons()
    }
    
    private func setUpStackView() {
        let stackViewMultiplier = 0.05
        let leadingTrailingInset = 32
        let iconTextSpacing = 10
        let iconSize = 19
        let spacing = 10
        let screenSize = UIScreen.main.bounds
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 25
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackViewMultiplier * screenSize.height)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0.15 * screenSize.height)
        }
        
        guard let ride = currentRide else { return }
        guard let creator = currentRide?.creator else { return }
        
        creatorProfile.image = UIImage(named: "emptyimage") //TODO: Replaces once Backend finishes
        creatorProfile.contentMode = .scaleAspectFill
        creatorProfile.layer.borderWidth = 1
        creatorProfile.layer.masksToBounds = false
        creatorProfile.layer.borderColor = UIColor.black.cgColor
        creatorProfile.layer.cornerRadius = 20.5
        creatorProfile.clipsToBounds = true
        driverInfoContainerView.addSubview(creatorProfile)
        creatorProfile.snp.makeConstraints { make in
            make.size.equalTo(41)
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        creatorLabel.text = "\(creator.firstName) \(creator.lastName)"
        driverInfoContainerView.addSubview(creatorLabel)
        creatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorProfile.snp.trailing).inset(-iconTextSpacing)
            make.top.equalTo(creatorProfile)
        }
        
        driverInfoContainerView.addSubview(mailIcon)
        mailIcon.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.leading.equalTo(creatorLabel)
            make.bottom.equalTo(creatorProfile)
        }
        
        creatorEmail.text = "\(creator.netid)@cornell.edu"
        driverInfoContainerView.addSubview(creatorEmail)
        creatorEmail.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom)
            make.leading.equalTo(mailIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(driverInfoContainerView)
        driverInfoContainerView.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
        
        transportationMethod.text = "TRANSPORTATION METHOD"
        transportationContainerView.addSubview(transportationMethod)
        transportationMethod.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        transportationContainerView.addSubview(carIcon)
        carIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(transportationMethod)
            make.top.equalTo(transportationMethod.snp.bottom).inset(-spacing)
        }
        
        driverType.text = ride.type
        transportationContainerView.addSubview(driverType)
        driverType.snp.makeConstraints { make in
            make.top.equalTo(carIcon)
            make.leading.equalTo(carIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(transportationContainerView)
        transportationContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        locations.text = "LOCATIONS"
        locationsContainerView.addSubview(locations)
        locations.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        locationsContainerView.addSubview(departureIcon)
        departureIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(locations)
            make.top.equalTo(locations.snp.bottom).inset(-spacing)
        }
        
        departureLocationLabel.text = ride.path.startLocationName
        locationsContainerView.addSubview(departureLocationLabel)
        departureLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(departureIcon)
            make.leading.equalTo(departureIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        locationsContainerView.addSubview(iconSeperator)
        iconSeperator.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.width.equalTo(1.5)
            make.leading.equalTo(locations).inset(8)
            make.top.equalTo(departureIcon.snp.bottom).inset(-spacing)
        }
        
        locationsContainerView.addSubview(arrivalIcon)
        arrivalIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(locations)
            make.top.equalTo(iconSeperator.snp.bottom).inset(-spacing)
        }
        
        arrivalLocationLabel.text = ride.path.endLocationName
        locationsContainerView.addSubview(arrivalLocationLabel)
        arrivalLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalIcon)
            make.leading.equalTo(arrivalIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(locationsContainerView)
        locationsContainerView.snp.makeConstraints { make in
            make.height.equalTo(85)
        }
        
        departureDateLabel.text = "DEPARTURE DATE"
        dateContainerView.addSubview(departureDateLabel)
        departureDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        dateContainerView.addSubview(calendarIcon)
        calendarIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(departureDateLabel)
            make.top.equalTo(departureDateLabel.snp.bottom).inset(-spacing)
        }
        
        departureDate.text = ride.departureDatetime
        dateContainerView.addSubview(departureDate)
        departureDate.snp.makeConstraints { make in
            make.top.equalTo(calendarIcon)
            make.leading.equalTo(calendarIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(dateContainerView)
        dateContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        numberTravelersLabel.text = "NUMBER OF TRAVELERS"
        numberTravelersContainerView.addSubview(numberTravelersLabel)
        numberTravelersLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        numberTravelers.text = "\(ride.minTravelers) to \(ride.maxTravelers) people"
        numberTravelersContainerView.addSubview(numberTravelers)
        numberTravelers.snp.makeConstraints { make in
            make.top.equalTo(numberTravelersLabel.snp.bottom).inset(-spacing)
            make.leading.equalTo(numberTravelers)
        }
        
        stackView.addArrangedSubview(numberTravelersContainerView)
        numberTravelersContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        detailsLabel.text = "DETAILS"
        detailsContainerView.addSubview(detailsLabel)
        detailsLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        detailsTextView.text = ride.description
        detailsTextView.font = UIFont(name: "SFPro", size: 16)
        detailsTextView.textColor = .black
        detailsContainerView.addSubview(detailsTextView)
        detailsTextView.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).inset(-spacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(detailsContainerView)
        detailsContainerView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }
    
    private func setUpButton() {
        requestButton.setTitle("Request to Join", for: .normal)
        requestButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        requestButton.backgroundColor = UIColor.scoopGreen
        requestButton.layer.cornerRadius = 25
        requestButton.addTarget(self, action: #selector(requestRide), for: .touchUpInside)
        view.addSubview(requestButton)
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(51)
            make.width.equalTo(296)
        }
    }
    
    @objc private func requestRide() {
        //TODO: Networking Goes here
        self.dismiss(animated: true)
        print("press")
    }
    
    private func setUpLabelFont() {
        [transportationMethod, locations, departureDateLabel, numberTravelersLabel, detailsLabel].forEach { label in
            label.font = UIFont(name: "Rambla-Regular", size: 16)
            label.textColor = .black
        }
    }
    
    private func setUpTextFont() {
        [creatorLabel, creatorEmail, driverType, arrivalLocationLabel, departureLocationLabel, departureDate, numberTravelers].forEach { textView in
            textView.font = UIFont(name: "SFPro-Regular", size: 16)
            textView.textColor = .black
        }
    }
    
    private func setUpIcons() {
        [mailIcon, carIcon, arrivalIcon, departureIcon, calendarIcon, iconSeperator].forEach { image in
            image.contentMode = .scaleAspectFill
        }
    }
    
}