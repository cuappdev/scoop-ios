//
//  PostRideSummaryViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import UIKit

class PostRideSummaryViewController: PostRideViewController {
    
    private let iconTextSpacing = 10
    private let iconSize = 19
    private let spacing = 10
    
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
    
    init(currentRide: Ride) {
        super.init(nibName: nil, bundle: nil)
        self.currentRide = currentRide
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: Not good practice, but temporary fix. Will Debug later
    override func viewDidAppear(_ animated: Bool) {
        updateBackButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let creator = currentRide?.creator else { return }
        setUpStackView()
        setUpButton()
        setUpLabelFont()
        setUpTextFont()
        setUpIcons()
        updateBackButton()
    }
    
    private func setUpStackView() {
        let stackViewMultiplier = 0.0
        let leadingTrailingInset = 32
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
        
        setUpDriverInfo()
        setUpTransportationInfo()
        setUpLocationInfo()
        setUpDateInfo()
        setUpTravelerInfo()
        setUpDetailsInfo()
    }
    
    private func setUpDriverInfo() {
        guard let creator = currentRide?.creator else { return }
        guard let imageURL = creator.profilePicUrl else {return}
        
        creatorProfile.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "emptyimage"))
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
    }
    
    private func setUpTransportationInfo() {
        guard let ride = currentRide else { return }
        
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
    }
    
    private func setUpLocationInfo() {
        guard let ride = currentRide else { return }
        
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
    }
    
    private func setUpDateInfo() {
        guard let ride = currentRide else { return }
        
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
    }
    
    private func setUpTravelerInfo() {
        guard let ride = currentRide else { return }
        
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
    }
    
    private func setUpDetailsInfo() {
        guard let ride = currentRide else { return }
        
        detailsLabel.text = "DETAILS"
        stackView.addArrangedSubview(detailsLabel)
        
        stackView.setCustomSpacing(6, after: detailsLabel)
        
        detailsTextView.text = ride.description
        detailsTextView.font = UIFont(name: "SFPro", size: 16)
        detailsTextView.textColor = .black
        detailsTextView.isEditable = false
        stackView.addArrangedSubview(detailsTextView)

        detailsTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private func setUpButton() {
        requestButton.setTitle("Post trip", for: .normal)
        requestButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        requestButton.backgroundColor = UIColor.scoopGreen
        requestButton.layer.cornerRadius = 25
        requestButton.addTarget(self, action: #selector(postRide), for: .touchUpInside)
        view.addSubview(requestButton)
        
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).inset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(51)
            make.width.equalTo(296)
        }
    }
    
    @objc private func postRide() {
        //TODO: Networking Goes here
        dismiss(animated: true)
        containerDelegate?.navigationController?.popViewController(animated: true)
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
